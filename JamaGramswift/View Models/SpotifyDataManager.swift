//
//  SpotifyDataManager.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/12/23.
//

import Foundation

struct Constants {
    static let baseURL: String = "https://api.spotify.com/v1"
}

class SpotifyDataManager: ObservableObject {
    @Published var isRetrievingData: Bool = false
    static var instance = SpotifyDataManager()
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    func createRequest(url: URL?, type: HTTPMethod) async throws -> URLRequest {
        let token = await SpotifyAuthManager.withCurrentToken()
        guard let url = url else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = type.rawValue
        request.timeoutInterval = 50
        return request
    }
    
    func getProfile() async throws -> User? {
        do {
            await MainActor.run {
                isRetrievingData = true
            }
            
            let profileRequest = try await createRequest(url: URL(string: Constants.baseURL + "/me"), type: .GET)
            
            let (data, response) = try await URLSession.shared.data(for: profileRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("error with fetching data")
            }
            
            //            let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            //
            //            print(result)
            
            let currentUser = try JSONDecoder().decode(User.self, from: data)
            
            await MainActor.run {
                isRetrievingData = false
            }
            
            return currentUser
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getTopArtist() async throws -> topArtistModel? {
        do {
            await MainActor.run {
                isRetrievingData = true
            }
            
            let artistRequest = try await createRequest(url: URL(string: Constants.baseURL + "/me/top/artists?limit=5&time_range=short_term"), type: .GET)
            
            let (data, _) = try await URLSession.shared.data(for: artistRequest)
            
            let topArtist = try JSONDecoder().decode(topArtistModel.self, from: data)
            
            await MainActor.run {
                isRetrievingData = false
                
                for item in topArtist.items {
                    ContentView.favArtists += item.id
                    ContentView.favArtists += ","
                }
            }
            
            return topArtist
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getRecomended() async -> recommendation? {
        do {
            await MainActor.run {
                isRetrievingData = true
            }
            
            let recommended = try await createRequest(url: URL(string: Constants.baseURL + "/recommendations?seed_artists=\(ContentView.favArtists)&limit=50"), type: .GET)
            
            let (data, _) = try await URLSession.shared.data(for: recommended)
            
            let recommendation = try JSONDecoder().decode(recommendation.self, from: data)
            
            print(recommendation)
            
            await MainActor.run {
                isRetrievingData = false
            }
            
            return recommendation
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

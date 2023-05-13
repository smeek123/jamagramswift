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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        return request
    }
    
    func getProfile() async throws -> User? {
        do {
            await MainActor.run {
                isRetrievingData = true
            }
            
            let profileRequest = try await createRequest(url: URL(string: Constants.baseURL + "/me"), type: .GET)
            
            let (data, response) = try await URLSession.shared.data(for: profileRequest)
            
//            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//                fatalError("error with fetching data")
//            }
            
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
}

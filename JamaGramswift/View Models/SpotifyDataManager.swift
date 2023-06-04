//
//  SpotifyDataManager.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/12/23.
//

import Foundation

//the base url for each request
struct Constants {
    static let baseURL: String = "https://api.spotify.com/v1"
}

//this class holds methods for requesting specific data from the api
//source for all functions is the spotify documentaion
class SpotifyDataManager: ObservableObject {
    //is true when data is loading
    @Published var isRetrievingData: Bool = false
    static var instance = SpotifyDataManager()
    
    enum playlistError: Error {
        case noUserId
    }
    
    //the requests are either post or get in this project so this allows for easy access to these types
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    //creates a basic request so we don't have a lot of repeated code
    //source ios academy
    func createRequest(url: URL?, type: HTTPMethod) async throws -> URLRequest {
        //uses the current token we have
        let token = await SpotifyAuthManager.withCurrentToken()
        guard let url = url else {
            throw URLError(.badURL)
        }
        
        //makes a request with the url passed in
        var request = URLRequest(url: url)
        //passes the token in so spotify knows whos getting data
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = type.rawValue
        request.timeoutInterval = 50
        return request
    }
    
    //this func gets the current users profile
    func getProfile() async throws -> User? {
        do {
            await MainActor.run {
                isRetrievingData = true
            }
            
            //creates a request using the basic request from above and passing in tge type and adding the endpoint to the url
            let profileRequest = try await createRequest(url: URL(string: Constants.baseURL + "/me"), type: .GET)
            
            //performs the request
            let (data, response) = try await URLSession.shared.data(for: profileRequest)
            
            //checks that the response is 200 which means its a good response
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
                fatalError("error with fetching data")
            }
            
            //decodes the user using the model we created so we can later access each field such as username
            let currentUser = try JSONDecoder().decode(User.self, from: data)
            
            await MainActor.run {
                isRetrievingData = false
            }
            
            return currentUser
        } catch {
            //prints any errors
            print(error.localizedDescription)
            return nil
        }
    }
    
    //this func gets the users favorite artists and is used while getting recommendations
    func getTopArtist() async throws -> topArtistModel? {
        do {
            await MainActor.run {
                isRetrievingData = true
            }
            
            //creates a request with the basic request and adds the type and correct endpoint
            let artistRequest = try await createRequest(url: URL(string: Constants.baseURL + "/me/top/artists?limit=5&time_range=short_term"), type: .GET)
            
            //performs the request, the _ means the response is ignored but the data is stored
            let (data, _) = try await URLSession.shared.data(for: artistRequest)
            
            //decoded data into the artist model
            let topArtist = try JSONDecoder().decode(topArtistModel.self, from: data)
            
            await MainActor.run {
                isRetrievingData = false
                
                //sets the list of topartists to be used later
                HomeView.favArtists = ""
                
                //loops through the data and creates a comma separated list that we can pass to spotify for recommendations
                for item in topArtist.items {
                    HomeView.favArtists += item.id
                    HomeView.favArtists += ","
                }
            }
            
            return topArtist
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    //this functions returns a list of 50 recommended tracks
    func getRecomended() async -> recommendation? {
        do {
            await MainActor.run {
                isRetrievingData = true
            }
            
            //creates the request with the basic request, the type and the top artists we got earlier
            let recommended = try await createRequest(url: URL(string: Constants.baseURL + "/recommendations?seed_artists=\(HomeView.favArtists)&limit=50"), type: .GET)
            
            //performs the request
            let (data, _) = try await URLSession.shared.data(for: recommended)
            
            //decodes into the model
            let recommendation = try JSONDecoder().decode(recommendation.self, from: data)
            
            print(recommendation)
            
            await MainActor.run {
                isRetrievingData = false
            }
            
            return recommendation
        } catch {
            print("reco")
            print(error.localizedDescription)
            return nil
        }
    }
    
    //started working on this method but is not funtional or complete for creating a list of favorites
    func createPlaylist() async throws -> PlaylistResponse? {
        do {
            await MainActor.run {
                isRetrievingData = true
            }
            
            guard let userId: String = try await getProfile()?.id else {
                throw playlistError.noUserId
            }
            
            let playlistRequest = try await createRequest(url: URL(string: Constants.baseURL + "/users/\(userId)/playlists?name=JamaGram&public=false"), type: .POST)
            
            guard let data = playlistRequest.httpBody else {
                throw URLError(.dataNotAllowed)
            }
            
            let (responseData, _) = try await
            URLSession.shared.upload(for: playlistRequest, from: data)
            
            let result = try JSONDecoder().decode(PlaylistResponse.self, from: responseData)
            
            await MainActor.run {
                isRetrievingData = false
            }
            
            return result
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}

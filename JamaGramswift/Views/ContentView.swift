//
//  ContentView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/5/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var spotifyData = SpotifyDataManager()
    @StateObject var spotify = SpotifyAuthManager()
    @AppStorage("signedIn") var isSignedIn: Bool = false
    @AppStorage("playlistId") var playlistId: String = ""
    
    var body: some View {
        //this is the main view that loads
        //if the user is signed into spotify, it shows the home
        //if not, it shows the login view
        VStack {
            if isSignedIn {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    ProfileView()
                        .tabItem {
                            Label("Me", systemImage: "person.circle")
                        }
                }
            } else {
                SignInView()
            }
        }
        //this function handles the url code that is opened
        .onOpenURL { url in
            Task {
                await spotify.HandleURLCode(url)
                
//                do {
//                    playlistId = try await spotifyData.createPlaylist()?.id ?? ""
//                } catch {
//                    print(error.localizedDescription)
//                }
            }
        }
        //this requests a new token when needed
        .task {
            if SpotifyAuthManager.shouldRefresh {
                try? await SpotifyAuthManager.getRefreshedAccessToken()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

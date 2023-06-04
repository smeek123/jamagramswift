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
    
    var body: some View {
        //this is the main view that loads
        //if the user is signed into spotify, it shows the home
        //if not, it shows the login view
        VStack {
            //If the user is signed, the tab view is shown
            if isSignedIn {
                TabView {
                    //when this tab is selected, the home view is shown. This is the default tab so will be automatically selected when the app loads.
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    //profile is shown when this tab is chosen
                    ProfileView()
                        .tabItem {
                            Label("Me", systemImage: "person.circle")
                        }
                }
            } else {
                //shows the signin view if the user is not signed in
                SignInView()
            }
        }
        //this function handles the url code that is opened after the spotify sign in screen sends you back to the app
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


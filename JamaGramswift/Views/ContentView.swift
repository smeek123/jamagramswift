//
//  ContentView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/5/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var spotify = SpotifyAuthManager()
    @AppStorage("signedIn") var isSignedIn: Bool = false
    
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
                    
                    Text("Favorites")
                        .tabItem {
                            Label("Favorites", systemImage: "star")
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

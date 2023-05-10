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
        VStack {
            if isSignedIn {
                TabView {
                    Text("Home")
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    
                    Text("Favorites")
                        .tabItem {
                            Label("Favorites", systemImage: "star")
                        }
                    
                    Text("Me")
                        .tabItem {
                            Label("Me", systemImage: "person.circle")
                        }
                }
            } else {
                SignInView()
            }
        }
        .onOpenURL { url in
            Task {
                await spotify.HandleURLCode(url)
            }
        }
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

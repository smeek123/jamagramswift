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
    @State private var selection: Int = 0
    
    var body: some View {
        //this is the main view that loads
        //if the user is signed into spotify, it shows the home
        //if not, it shows the login view
        VStack {
            //If the user is signed, the tab view is shown
            if isSignedIn {
                TabView(selection: $selection) {
                    HomeView()
                        .tabItem {
                            if selection == 0 {
                                Image(systemName: "house.fill")
                            } else {
                                Image(systemName: "house")
                                    .environment(\.symbolVariants, .none)
                            }
                        }.tag(0)
                    
                    SearchView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                        }.tag(1)
                    
                    CreateView()
                        .tabItem {
                            if selection == 2 {
                                Image(systemName: "plus.app.fill")
                            } else {
                                Image(systemName: "plus.app")
                                    .environment(\.symbolVariants, .none)
                            }
                        }.tag(2)
                    
                    TrendingView()
                        .tabItem {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                        }.tag(3)
                    
                    ProfileView()
                        .tabItem {
                            if selection == 4 {
                                Image(systemName: "person.circle.fill")
                            } else {
                                Image(systemName: "person.circle")
                                    .environment(\.symbolVariants, .none)
                            }
                        }.tag(4)
                }
            } else {
                //shows the signin view if the user is not signed in
                SignInView()
            }
        }
        .accentColor(.primary)
        //this function handles the url code that is opened after the spotify sign in screen sends you back to the app
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


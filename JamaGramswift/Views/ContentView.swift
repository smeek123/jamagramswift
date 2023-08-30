//
//  ContentView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/5/23.
//functions for getting user data

import SwiftUI

struct ContentView: View {
    @StateObject var spotifyData = SpotifyDataManager()
    @StateObject var spotify = SpotifyAuthManager()
    @AppStorage("signedIn") var isSignedIn: Bool = false
    @StateObject var viewModel = ContentViewModel()
    @StateObject var regViewModel = RegistrationViewModel()
    
    var body: some View {
        Group {
            if viewModel.userSession == nil {
                SignInOptionsView()
                    .environmentObject(regViewModel)
            } else if let currentUser = viewModel.currentUser {
                MainTabView(user: currentUser)
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
    }
}


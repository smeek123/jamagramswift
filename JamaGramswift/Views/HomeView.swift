//
//  HomeView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/16/23.
//

import SwiftUI

//this is the view shown on the first tab item. It creates a stack of card views to be swiped.
struct HomeView: View {
    //gives access to spotify data view model methods
    @StateObject var spotifyData = SpotifyDataManager()
    //holds the result of the api request to the spotify recommendations
    @State var tracks: [track] = []
    //this is used to pass in a list of artists that the recommendation function bases its suggestions off of.
    @AppStorage("favArtists") static var favArtists: String = ""
    @State private var showCreate: Bool = false
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                LazyVStack {
                    ForEach(viewModel.posts) { post in
                        PostView(post: post)
                    }
                }
                .padding(.vertical, 10)
                .fullScreenCover(isPresented: $showCreate) {
                    CreateView()
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("JamaGram")
                        .foregroundColor(.primary)
                        .font(.system(size: 25))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        Text("Notifications")
                    } label: {
                        Image(systemName: "bell")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreate.toggle()
                    } label: {
                        Image(systemName: "plus.app")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                    }
                }
                
                //                ToolbarItem(placement: .navigationBarTrailing) {
                //                    NavigationLink {
                //                        Text("Messages")
                //                    } label: {
                //                        Image(systemName: "message")
                //                            .foregroundColor(.primary)
                //                            .font(.system(size: 20))
                //                    }
                //                }
            }
            .task {
                _ = try? await spotifyData.getTopArtist()
                tracks = await spotifyData.getRecomended()?.tracks ?? []
            }
        }
    }
}

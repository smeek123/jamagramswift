//
//  HomeView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/16/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject var spotifyData = SpotifyDataManager()
    @State var tracks: [track] = []
    @AppStorage("favArtists") static var favArtists: String = ""
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(tracks) { track in
                    CardView(track: track)
                }
            }
        }
        .task {
            _ = try? await spotifyData.getTopArtist()
            tracks = await spotifyData.getRecomended()?.tracks ?? []
        }
    }
}

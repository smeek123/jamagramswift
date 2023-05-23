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
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(tracks) { track in
                    CardView(track: track)
                }
            }
        }
        .task {
            tracks = await spotifyData.getRecomended()?.tracks ?? []
        }
    }
}

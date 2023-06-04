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
    
    var body: some View {
        VStack {
            ZStack {
                //loops through the tracks list and for every item creates an instance of card view and adds it to the stack
                ForEach(tracks) { track in
                    CardView(track: track)
                }
            }
        }
        //this gets the top artists which are passed into the recommendation method
        .task {
            _ = try? await spotifyData.getTopArtist()
            tracks = await spotifyData.getRecomended()?.tracks ?? []
        }
    }
}

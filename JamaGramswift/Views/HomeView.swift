//
//  HomeView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/16/23.
//

import SwiftUI

struct HomeView: View {
    private var tracks: [String] = ["F.N.", "20 min", "Lucid Dreams", "Zoo York"]
    
    var body: some View {
        VStack {
            ZStack {
                ForEach(tracks, id: \.self) { track in
                    CardView(track: track)
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

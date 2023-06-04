//
//  PlaylistModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/30/23.
//

import Foundation

//started model for playlists but not complete yet
struct Playlist: Codable {
    let id: String
    let tracks: [track]
}

struct PlaylistResponse: Codable {
    let id: String
}

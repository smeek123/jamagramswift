//
//  PlaylistModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/30/23.
//

import Foundation

struct Playlist: Codable {
    let id: String
    let tracks: [track]
}

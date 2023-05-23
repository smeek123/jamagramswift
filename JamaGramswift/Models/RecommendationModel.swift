//
//  RecommendationModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/23/23.
//

import Foundation

struct recommendation: Codable {
    let tracks: [track]
}

struct track: Codable, Identifiable {
    let album: album
    let artists: [artistItem]?
    let explicit: Bool?
    let id: String
    let name: String
    let uri: String
    let preview_url: String?
}

struct album: Codable {
    let images: [APIImage]
}

//
//  TopArtistModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/23/23.
//

import Foundation

//holds fields for the top artists
struct topArtistModel: Codable {
    let items: [artistItem]
}

//decodes an artist which is used as part of other models
struct artistItem: Codable {
    let images: [APIImage]?
    let name: String
    let uri: String
    let id: String
}

struct topTrackModel: Codable {
    let items: [track]
}

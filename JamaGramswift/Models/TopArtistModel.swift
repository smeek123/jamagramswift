//
//  TopArtistModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/23/23.
//

import Foundation

struct topArtistModel: Codable {
    let items: [artistItem]
}

struct artistItem: Codable {
    let images: [APIImage]?
    let name: String
    let uri: String
    let id: String
}

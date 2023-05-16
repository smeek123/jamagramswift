//
//  User.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/12/23.
//

import Foundation

//this model allows us to decode the data return from the user profile request
struct User: Codable {
    let display_name: String
//    let external_urls: [String: String]
    let id: String
    let product: String
    let uri: String
    let images: [APIImage]?
}

//this helps with the image section of the data
struct APIImage: Codable {
    let url: String
}

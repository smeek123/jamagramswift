//
//  PostModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/22/23.
//

import Foundation

struct Post: Identifiable, Codable, Hashable {
    let id: String
    let songURI: String?
    let ownerUid: String
    let caption: String
    var numLikes: Int
    let imageURL: String
    let timeStamp: Date
    var user: FireUser?
}

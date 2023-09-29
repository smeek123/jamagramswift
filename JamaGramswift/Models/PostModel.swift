//
//  PostModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/22/23.
//

import Foundation
import Firebase

struct Post: Identifiable, Codable, Hashable {
    let id: String
    let songURI: String?
    let ownerUid: String
    let caption: String
    let imageUrl: String
    let timeStamp: Timestamp
    var user: FireUser?
    var likers: [String]
}

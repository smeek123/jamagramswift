//
//  PostModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/22/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Post: Identifiable, Codable, Hashable {
    let id: String
    let songURI: String?
    let ownerUid: String
    let caption: String
    var numLikes: Int
    let imageUrl: String
    let timeStamp: Timestamp
    var user: FireUser?
}

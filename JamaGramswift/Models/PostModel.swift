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
    let artist: String
    let trackName: String
    let ownerUid: String
    let caption: String
    let imageUrl: String
    let timeStamp: Timestamp
    var user: FireUser?
    var likers: [String]
    var searchTerms: [String] {
        if let username = self.user?.username {
            return [username.lowercased().generateStringSequence(), self.trackName.lowercased().generateStringSequence(), self.artist.lowercased().generateStringSequence()].flatMap {$0}
        } else {
            return [self.trackName.lowercased().generateStringSequence(), self.artist.lowercased().generateStringSequence()].flatMap {$0}
        }
    }
}

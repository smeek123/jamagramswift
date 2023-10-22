//
//  UserModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/22/23.
//

import SwiftUI
import Foundation
import Firebase

struct FireUser: Identifiable, Codable, Hashable {
    let id: String
    var username: String
    var profileImageUrl: String?
    var name: String?
    var bio: String?
    var email: String
    var saves: [String]?
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return false
        }
        return currentUid == id
    }
    var searchTerms: [String] {
        if let name = self.name {
            return [self.username.lowercased().generateStringSequence(), name.lowercased().generateStringSequence()].flatMap {$0}
        } else {
            return [self.username.lowercased().generateStringSequence()].flatMap {$0}
        }
    }
}

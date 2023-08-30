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
    var profileImageURL: String?
    var name: String?
    var bio: String?
    var email: String
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return false
        }
        return currentUid == id
    }
}

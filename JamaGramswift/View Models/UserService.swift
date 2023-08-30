//
//  UserService.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/29/23.
//

import Foundation
import Firebase

struct UserService {
    static func fetchAllUsers() async throws -> [FireUser] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: FireUser.self) })
    }
}

//
//  UserService.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/29/23.
//

import Foundation
import FirebaseFirestore

struct UserService {
    static func fetchUser(uid: String) async throws -> FireUser {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        return try snapshot.data(as: FireUser.self)
    }
    
    static func addUserListener(uid: String, completion: @escaping (_ user: FireUser) -> Void) {
        Firestore.firestore().collection("users").document(uid).addSnapshotListener { querySnapshot, error in
            guard let document = querySnapshot else {
                return
            }
            
            let user = try? document.data(as: FireUser.self)
            completion(user ?? FireUser(id: "Id", username: "", email: ""))
        }
    }
    
    static func fetchAllUsers() async throws -> [FireUser] {
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: FireUser.self) })
    }
}

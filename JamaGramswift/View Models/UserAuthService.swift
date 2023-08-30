//
//  UserAuthService.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/24/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift
import Firebase

class UserAuthService {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: FireUser?
    static let shared = UserAuthService()
    
    init() {
        Task {
            try await loadUserDate()
        }
    }
    
    @MainActor
    func loginWithEmail(with email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            try await loadUserDate()
        } catch {
            print("failed to log user in with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func createUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            await uploadUserData(uid: result.user.uid, username: username, email: email)
        } catch {
            print("failed to register user with error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func loadUserDate() async throws {
        self.userSession = Auth.auth().currentUser
        guard let currentUid = userSession?.uid else {
            return
        }
        let snapshot = try await Firestore.firestore().collection("users").document(currentUid).getDocument()
        self.currentUser = try? snapshot.data(as: FireUser.self)
    }
    
    private func uploadUserData(uid: String, username: String, email: String) async {
        let user = FireUser(id: uid, username: username, email: email)
        self.currentUser = user
        guard let encodedUser = try? Firestore.Encoder().encode(user) else {
            return
        }
        
        try? await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
    }
    
    func signout() {
        try? Auth.auth().signOut()
        self.userSession = nil
        self.currentUser = nil
    }
}

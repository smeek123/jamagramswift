//
//  UserAuthService.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/24/23.
//

import Foundation
import FirebaseAuth

class UserAuthService {
    @Published var userSession: FirebaseAuth.User?
    static let shared = UserAuthService()
    
    init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func loginWithEmail(with email: String, password: String) async throws {
        
    }
    
    func createUser(email: String, password: String, username: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
        } catch {
            print("failed to register user with error \(error.localizedDescription)")
        }
    }
    
    func loadUserDate() async throws {
        
    }
    
    func signout() {
        try? Auth.auth().signOut()
        self.userSession = nil
    }
}

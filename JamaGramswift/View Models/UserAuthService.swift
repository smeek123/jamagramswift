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
        
    }
    
    func loadUserDate() async throws {
        
    }
    
    func signout() {
        
    }
}

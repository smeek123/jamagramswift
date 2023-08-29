//
//  RegistrationViewModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/24/23.
//

import Foundation

class RegistrationViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    
    func createUser() async throws {
        try await UserAuthService.shared.createUser(email: email, password: password, username: username)
        
        await MainActor.run {
            email = ""
            password = ""
            username = ""
        }
    }
}

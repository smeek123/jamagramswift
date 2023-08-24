//
//  LoginViewModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/24/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        try await UserAuthService.shared.loginWithEmail(with: email, password: password)
    }
}

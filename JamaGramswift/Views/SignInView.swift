//
//  SignInView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/6/23.
//

import SwiftUI

struct SignInView: View {
    @StateObject var loginViewModel = LoginViewModel()
    @Environment(\.dismiss) var dismiss
    @State private var isActive: Bool = false
    @State private var readyToNavigate: Bool = false
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Text("Sign in with email")
                .foregroundColor(.primary)
                .font(.title)
                .multilineTextAlignment(.center)
            
            TextField("Enter your email address", text: $loginViewModel.email)
                .modifier(TextFieldModifier())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Enter your password", text: $loginViewModel.password)
                .modifier(TextFieldModifier())
            
            Button {
                Task {
                    if !loginViewModel.email.isEmpty && !loginViewModel.password.isEmpty {
                        try await loginViewModel.signIn()
                    }
                }
            } label: {
                LargeButtonView(title: "Log In", isActive: !loginViewModel.email.isEmpty && loginViewModel.password.count >= 8)
            }
            .disabled(loginViewModel.email.isEmpty || loginViewModel.password.count < 8)
            
            Spacer()
            
            NavigationLink {
                Text("Reset")
                    .navigationBarBackButtonHidden()
            } label: {
                Text("Forgot password")
                    .foregroundColor(Color("MainColor"))
                    .padding(.vertical)
                    .font(.footnote)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .font(.system(size: 20))
                }
            }
        }
    }
}



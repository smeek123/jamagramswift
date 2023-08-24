//
//  SignInView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/6/23.
//

import SwiftUI

struct SignInView: View {
    @Environment(\.dismiss) var dismiss
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Text("Sign in with email")
                .foregroundColor(.primary)
                .font(.title)
                .multilineTextAlignment(.center)
            
            TextField("Enter your email address", text: $email)
                .modifier(TextFieldModifier())
                .autocapitalization(.none)
            
            SecureField("Enter your password", text: $password)
                .modifier(TextFieldModifier())
            
            Button {
                
            } label: {
                LargeButtonView(title: "Log In")
            }
            
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



//
//  SignInView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/6/23.
//

import SwiftUI

struct SignInView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 25) {
                Spacer()
                
                Text("JamaGram")
                    .foregroundColor(.primary)
                    .font(.system(size: 35))
                
                TextField("Enter your email address", text: $email)
                    .modifier(TextFieldModifier())
                
                SecureField("Enter your password", text: $password)
                    .modifier(TextFieldModifier())
                
                Button {
                    
                } label: {
                    LargeButtonView(title: "Log In")
                }
                
                Spacer()
                
                NavigationLink {
                    Text("")
                } label: {
                    Text("Don't have an account? Sign up now.")
                        .foregroundColor(Color("MainColor"))
                        .padding(.vertical)
                }
            }
        }
    }
}



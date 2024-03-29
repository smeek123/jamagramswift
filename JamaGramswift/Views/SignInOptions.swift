//
//  SignInOptions.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/19/23.
//

import SwiftUI

struct SignInOptionsView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("JamaGram")
                    .foregroundColor(.primary)
                    .font(.largeTitle)
                    .padding(.vertical)
                
                Text("Welcome to JamaGram! The best place to share your favorite music with friends.")
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .font(.headline)
                
                VStack(spacing: 30) {
                    NavigationLink {
                        SignInView()
                            .navigationBarBackButtonHidden()
                    } label: {
                        LargeButtonView(title: "Sign in with Email", isActive: true)
                    }
                    
                    NavigationLink {
                        SignInView()
                    } label: {
                        LargeButtonView(title: "Sign in with Apple", isActive: true)
                    }
                }
                .padding(.vertical)
                
                Spacer()
                
                NavigationLink {
                    AddEmailView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Don't have an account? Sign up now!")
                        .foregroundColor(Color("MainColor"))
                        .padding(.vertical)
                        .font(.footnote)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 18)
        }
    }
}


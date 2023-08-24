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
                        LargeButtonView(title: "Sign in with Email")
                    }
                    
                    NavigationLink {
                        SignInView()
                    } label: {
                        LargeButtonView(title: "Sign in with Apple")
                    }
                    
                    NavigationLink {
                        SignInView()
                    } label: {
                        LargeButtonView(title: "Sign in with Google")
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

struct SignInOptions_Previews: PreviewProvider {
    static var previews: some View {
        SignInOptionsView()
    }
}

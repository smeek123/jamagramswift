//
//  AddEmailView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/23/23.
//

import SwiftUI

struct AddEmailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
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
            
            Text("Enter your email address")
                .foregroundColor(.primary)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Text("This email address will be used to log in to your account. It will not be visible to others.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .font(.headline)
                .padding(.horizontal, 18)
            
            TextField("Email address", text: $viewModel.email)
                .modifier(TextFieldModifier())
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
                .onChange(of: viewModel.email, initial: true) {
                    if isValidEmail(email: viewModel.email) {
                        isActive = true
                    } else {
                        isActive = false
                    }
                }
            
            Button {
                if isActive {
                    readyToNavigate.toggle()
                }
            } label: {
                LargeButtonView(title: "Next", isActive: isActive)
            }
            .disabled(!isActive)
            
            Spacer()
            
            Text("1/4")
                .foregroundColor(.secondary)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.vertical)
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
        .navigationDestination(isPresented: $readyToNavigate) {
            AddPasswordView()
                .navigationBarBackButtonHidden()
        }
    }
}



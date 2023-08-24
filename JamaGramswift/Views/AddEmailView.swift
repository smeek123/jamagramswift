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
            
            NavigationLink {
                AddPasswordView()
                    .navigationBarBackButtonHidden()
            } label: {
                LargeButtonView(title: "Next")
            }
            
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
    }
}

struct AddEmailView_Previews: PreviewProvider {
    static var previews: some View {
        AddEmailView()
    }
}

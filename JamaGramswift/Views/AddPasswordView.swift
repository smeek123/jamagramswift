//
//  AddPasswordView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/23/23.
//

import SwiftUI

struct AddPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @State private var confirm: String = ""
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Text("Create a password")
                .foregroundColor(.primary)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Text("Your password must be at least 8 characters long.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .font(.headline)
            
            SecureField("Enter password", text: $viewModel.password)
                .modifier(TextFieldModifier())
            
            SecureField("Confirm password", text: $confirm)
                .modifier(TextFieldModifier())
            
            NavigationLink {
                AddUsernameView()
                    .navigationBarBackButtonHidden()
            } label: {
                LargeButtonView(title: "Next")
            }

            Spacer()
            
            Text("2/4")
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



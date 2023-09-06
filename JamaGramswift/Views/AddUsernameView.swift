//
//  AddUsernameView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/23/23.
//

import SwiftUI

struct AddUsernameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Text("Create a username")
                .foregroundColor(.primary)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Text("Your username must be at least 3 characters long.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .font(.headline)
            
            TextField("Enter username", text: $viewModel.username)
                .modifier(TextFieldModifier())
                .autocapitalization(.none)
                .autocorrectionDisabled()
            
            NavigationLink {
                AddStreamingView()
                    .navigationBarBackButtonHidden()
            } label: {
                LargeButtonView(title: "Next")
            }

            Spacer()
            
            Text("3/4")
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


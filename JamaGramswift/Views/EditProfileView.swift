//
//  EditProfileView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 7/19/23.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditProfileViewModel
    
    init(user: FireUser) {
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                    }
                    
                    Spacer()
                    
                    Text("Customize")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            try await viewModel.updateUserData()
                        }
                        
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal)
                .padding()
                
                Divider()
                    .overlay(Color("MainColor"))
                    .padding(.vertical, 10)
                
                VStack(spacing: 15) {
                    PhotosPicker(selection: $viewModel.selectedImage, matching: .images) {
                        if let image = viewModel.profileImage {
                            image
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Section(header: HStack {
                        Text("Name")
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }) {
                        TextField("Enter your name", text: $viewModel.name)
                            .modifier(TextFieldModifier())
                    }
                    
                    Section(header: HStack {
                        Text("Bio")
                            .padding(.horizontal)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                    }) {
                        TextField("Add a Bio", text: $viewModel.bio)
                            .modifier(TextFieldModifier())
                    }
                }
                .padding()
                
                Spacer()
            }
        }
    }
}

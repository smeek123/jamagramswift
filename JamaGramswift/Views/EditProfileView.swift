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
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    
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
                        if viewModel.bio.count <= 200 {
                            isLoading = true
                            
                            Task {
                                try await viewModel.updateUserData()
                            }
                            
                            isLoading = false
                            
                            dismiss()
                        } else {
                            showError = true
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                    }
                }
                .padding(.horizontal)
                .padding()
                .alert("Your bio must be 200 characters or less.", isPresented: $showError) {
                    Button("OK", role: .cancel) {
                        
                    }
                }
                
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
                            ProfileImageView(user: viewModel.user, size: 100)
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
                        
                        Text("\(viewModel.bio.count)/200")
                            .padding(.horizontal)
                            .foregroundColor(viewModel.bio.count > 200 ? .red : .secondary)
                            .font(.footnote)
                    }) {
                        TextField("Add a Bio", text: $viewModel.bio, axis: .vertical)
                            .modifier(TextFieldModifier())
                            .lineLimit(5)
                    }
                }
                .padding()
                
                Spacer()
            }
            .overlay {
                if isLoading {
                    ProgressView()
                        .foregroundColor(Color("MainColor"))
                }
            }
        }
    }
}

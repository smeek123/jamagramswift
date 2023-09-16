//
//  CreateView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 7/15/23.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) var dismiss
    @State var song: String = ""
    @State var caption: String = ""
    @State private var isLoading: Bool = false
    @State private var showPhotoPicker: Bool = false
    @StateObject var viewModel = UploadPostViewModel()
    
    private func dismissView() {
        caption = ""
        song = ""
        viewModel.selectedImage = nil
        viewModel.postImage = nil
        dismiss()
    }
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Button {
                        dismissView()
                    } label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                    }
                    
                    Spacer()
                    
                    Text("Create")
                        .font(.subheadline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await MainActor.run {
                                isLoading = true
                            }
                            
                            try await viewModel.uploadPost(caption: caption, song: song)
                            
                            await MainActor.run {
                                isLoading = false
                            }
                            
                            dismissView()
                        }
                    } label: {
                        if isLoading {
                            ProgressView()
                                .tint(Color("MainColor"))
                                .font(.system(size: 20))
                        } else {
                            Image(systemName: "checkmark")
                                .foregroundColor(.primary)
                                .font(.system(size: 20))
                        }
                    }
                    .allowsHitTesting(!isLoading)
                }
                .padding(.horizontal)
                .padding()
                
                Divider()
                    .overlay(Color("MainColor"))
                    .padding(.vertical, 10)
                
                TextField("Search by track name", text: $song)
                    .modifier(TextFieldModifier())
                
                VStack(spacing: 3) {
                    if let image = viewModel.postImage {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 350, height: 350)
                            .clipped()
                            .padding()
                    } else {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFill()
                            .foregroundColor(.secondary)
                            .frame(width: 250, height: 250)
                            .padding()
                    }
                    
                    Text("Change photo")
                        .font(.footnote)
                        .foregroundColor(.primary)
                }
                .padding(.bottom)
                .onTapGesture {
                    showPhotoPicker.toggle()
                }
                
                TextField("Add a caption", text: $caption, axis: .vertical)
                    .lineLimit(5)
                    .modifier(TextFieldModifier())
                
                Spacer()
            }
            .photosPicker(isPresented: $showPhotoPicker, selection: $viewModel.selectedImage, matching: .images)
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}

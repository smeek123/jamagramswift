//
//  UserPostsView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 9/15/23.
//

import SwiftUI
import Kingfisher

struct UserPostsView: View {
    @StateObject var viewModel: UserPostsViewModel
    @State private var showDeleteMessage: Bool = false
    
    init(user: FireUser) {
        self._viewModel = StateObject(wrappedValue: UserPostsViewModel(user: user))
    }
    
    private let gridItem: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    private let imageSize: CGFloat = (UIScreen.main.bounds.width / 3) - 1
    
    var body: some View {
        if viewModel.userPosts.isEmpty {
            VStack {
                Image(systemName: "music.note.list")
                    .font(.system(size: 100))
                    .foregroundColor(.secondary)
                
                Text("No posts yet.")
                    .foregroundColor(.primary)
            }
        } else {
            LazyVGrid(columns: gridItem, spacing: 1) {
                ForEach(viewModel.userPosts) { post in
                    KFImage(URL(string: post.imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipped()
                        .contextMenu {
                            if let user = post.user {
                                if user.isCurrentUser {
                                    Button(role: .destructive) {
                                        showDeleteMessage.toggle()
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                } else {
                                    Button(role: .destructive) {
                                    } label: {
                                        Label("Report", systemImage: "exclamationmark.bubble")
                                    }
                                }
                            }
                        }
                        .alert("Delete Post?", isPresented: $showDeleteMessage, actions: {
                            Button(role: .destructive) {
                                Task {
                                    try? await viewModel.deletePost(id: post.id)
                                }
                            } label: {
                                Text("Delete")
                            }

                            Button(role: .cancel) {
                                
                            } label: {
                                Text("Cancel")
                            }
                        }, message: {
                            Text("This action cannot be undone.")
                        })
                }
            }
        }
    }
}

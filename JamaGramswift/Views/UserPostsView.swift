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
                Spacer()
                
                Image(systemName: "music.note.list")
                    .font(.system(size: 100))
                    .foregroundColor(.secondary)

                Text("No posts yet.")
                    .foregroundColor(.primary)
                
                Spacer()
            }
        } else {
            LazyVGrid(columns: gridItem, spacing: 1) {
                ForEach(viewModel.userPosts) { post in
                    KFImage(URL(string: post.imageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width: imageSize, height: imageSize)
                        .clipped()
                }
            }
        }
    }
}

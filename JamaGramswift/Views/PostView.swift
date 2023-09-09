//
//  PostView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/18/23.
//

import SwiftUI
import Kingfisher

struct PostView: View {
    @State private var like: Bool = false
    let post: Post
    
    var body: some View {
        VStack {
            HStack {
                if let user = post.user {
                    ProfileImageView(user: user, size: 40)
                    
                    Text(user.username)
                        .foregroundColor(.primary)
                        .font(.system(size: 15))
                }
                
                Spacer()
                
                Text("6h ago")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 8)
            
            KFImage(URL(string: post.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .clipShape(Rectangle())
            
            HStack(spacing: 15) {
                Button {
                    like.toggle()
                } label: {
                    Label {
                        Text(String(post.numLikes))
                    } icon: {
                        if like {
                            Image(systemName: "hands.clap.fill")
                                .font(.system(size: 25))
                                .foregroundColor(Color("MainColor"))
                        } else {
                            Image(systemName: "hands.clap")
                                .font(.system(size: 23))
                        }
                    }
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                }
                
                Image(systemName: "opticaldisc")
                    .font(.system(size: 23))
                
                Image(systemName: "bookmark")
                    .font(.system(size: 23))
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack(alignment: .center) {
                Image(systemName: "headphones")
                    .font(.system(size: 23))
                
                Text("2 Grown")
                    .lineLimit(1)
                    .foregroundColor(.primary)
                    .font(.system(size: 15))
                
                Spacer()
                
                Button {
                    
                } label: {
                    Text("Listen")
                        .font(.system(size: 15))
                }
                .buttonBorderShape(.capsule)
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 8)
            
            HStack(alignment: .center) {
                Text("\(post.user?.username ?? "") ")
                    .fontWeight(.bold) +
                Text(post.caption)
                
                Spacer()
            }
            .foregroundColor(.primary)
            .padding(.leading, 10)
            .multilineTextAlignment(.leading)
            .lineLimit(3)
            .font(.system(size: 15))
            .padding(5)
            
            Divider()
                .overlay(Color("MainColor"))
                .padding(.vertical, 10)
        }
    }
}

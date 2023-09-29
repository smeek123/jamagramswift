//
//  PostView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/18/23.
//

import Foundation
import SwiftUI
import Kingfisher
import Firebase

struct PostView: View {
    @StateObject var viewModel = FeedViewModel()
    @State private var like: Bool = false
    let post: Post
    let user: FireUser
    
//    func timeAgo(time: Timestamp) -> String {
//        if let timestamp = post?.timeStamp {
//            print(timestamp)
//            let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
//            let now = Date()
//            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
//            let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
//            
//            var timeText = ""
//            if diff.second! <= 0 {
//                timeText = "Now"
//            }
//            if diff.second! > 0 && diff.minute! == 0 {
//                timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
//            }
//            if diff.minute! > 0 && diff.hour! == 0 {
//                timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
//            }
//            if diff.hour! > 0 && diff.day! == 0 {
//                timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
//            }
//            if diff.day! > 0 && diff.weekOfMonth! == 0 {
//                timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
//            }
//            if diff.weekOfMonth! > 0 {
//                timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
//            }
//            
//            return timeText
//        }
//    }
    
    var body: some View {
        VStack {
            HStack {
                if let postUser = post.user {
                    ProfileImageView(user: postUser, size: 40)
                    
                    Text(postUser.username)
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
                        Text(String(post.likers.count))
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
                
                Button {
                    Task {
                        if let saves = user.saves {
                            if saves.contains(post.id) {
                                try? await viewModel.removeSavedPost(postId: post.id)
                            } else {
                                try? await viewModel.addSavedPost(postId: post.id)
                            }
                        }
                    }
                } label: {
                    if let saves = user.saves {
                        if saves.contains(post.id) {
                            Image(systemName: "bookmark.fill")
                                .font(.system(size: 23))
                        } else {
                            Image(systemName: "bookmark")
                                .font(.system(size: 23))
                        }
                    } else {
                        Image(systemName: "bookmark")
                            .font(.system(size: 23))
                    }
                }
                
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
            
            if post.caption != "" {
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
            }
            
            Divider()
                .overlay(Color("MainColor"))
                .padding(.vertical, 10)
        }
    }
}

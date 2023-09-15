//
//  FeedViewModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 9/8/23.
//

import Foundation
import Firebase

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    @MainActor
    func fetchPosts() async throws {
        let snapshot = try await Firestore.firestore().collection("posts").order(by: "timeStamp", descending: true).getDocuments()
        self.posts = try snapshot.documents.compactMap({ try $0.data(as: Post.self) })
        
        for i in 0 ..< posts.count {
            let post = posts[i]
            let ownerUid = post.ownerUid
            let postUser = try await UserService.fetchUser(uid: ownerUid)
            posts[i].user = postUser
        }
    }
}

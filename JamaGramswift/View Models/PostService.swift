//
//  PostService.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 9/14/23.
//

import Foundation
import Firebase

struct PostService {
    private static let postRef = Firestore.firestore().collection("posts")
    
    static func fetchFeedPosts() async throws -> [Post] {
        let snapshot = try await postRef.order(by: "timeStamp", descending: true).getDocuments()
        var posts = try snapshot.documents.compactMap({ try $0.data(as: Post.self) })
        
        for i in 0 ..< posts.count {
            let post = posts[i]
            let ownerUid = post.ownerUid
            let postUser = try await UserService.fetchUser(uid: ownerUid)
            posts[i].user = postUser
        }
        
        return posts
    }
    
    static func fetchUserPosts(uid: String) async throws -> [Post] {
        let snapshot = try await postRef
            .whereField("ownerUid", isEqualTo: uid)
            .order(by: "timeStamp", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap({try $0.data(as: Post.self)})
    }
    
    static func deletePost(id: String) async throws {
        try await postRef.document(id).delete()
    }
}

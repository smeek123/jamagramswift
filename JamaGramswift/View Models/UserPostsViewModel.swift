//
//  UserPostsViewModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 9/15/23.
//

import Foundation
import Firebase

class UserPostsViewModel: ObservableObject {
    @Published var userPosts = [Post]()
    @Published var savedPosts = [Post]()
    private let user: FireUser
    
    init(user: FireUser) {
        self.user = user
        
        Task {
            try await fetchUserPosts()
            try await fetchSavedPosts()
        }
    }
    
    @MainActor
    func fetchUserPosts() async throws {
        self.userPosts = try await PostService.fetchUserPosts(uid: user.id)
        
        for i in 0 ..< userPosts.count {
            userPosts[i].user = self.user
        }
    }
    
    @MainActor
    func deletePost(id: String) async throws {
        try await Firestore.firestore().collection("posts").document(id).delete()
        
        try await fetchUserPosts()
    }
    
    @MainActor
    func fetchSavedPosts() async throws {
        guard let posts = user.saves else {
            return
        }
        
        for i in stride(from: posts.count-1, to: -1, by: -1) {
            let snapshot = try await Firestore.firestore().collection("posts").document(posts[i]).getDocument()
            let saved = try snapshot.data(as: Post.self)
            self.savedPosts.append(saved)
        }
    }
}

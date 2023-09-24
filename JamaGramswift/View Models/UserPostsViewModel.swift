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
    private let user: FireUser
    
    init(user: FireUser) {
        self.user = user
        
        Task {
            try await fetchUserPosts()
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
}

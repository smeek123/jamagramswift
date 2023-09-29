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
        self.posts = try await PostService.fetchFeedPosts()
    }
    
    @MainActor
    func likePost(postId: String, userId: String) async throws {
        
    }
    
    func addSavedPost(postId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        try await Firestore.firestore().collection("users").document(uid).updateData(["saves": FieldValue.arrayUnion([postId])])
    }
    
    func removeSavedPost(postId: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        try await Firestore.firestore().collection("users").document(uid).updateData(["saves": FieldValue.arrayRemove([postId])])
    }
}

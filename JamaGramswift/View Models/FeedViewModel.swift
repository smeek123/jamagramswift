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
}

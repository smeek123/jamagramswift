//
//  SearchViewModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/30/23.
//

import Foundation

class SearchViewModel: ObservableObject {
    @Published var users = [FireUser]()
    
    init() {
        Task {
            try await fetchAllUsers()
        }
    }
    
    @MainActor
    func fetchAllUsers() async throws {
        self.users = try await UserService.fetchAllUsers()
    }
}

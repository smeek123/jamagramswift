//
//  ContentViewModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/24/23.
//

import Foundation
import Firebase
import Combine

class ContentViewModel: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private let service = UserAuthService.shared
    @Published var userSession: FirebaseAuth.User?
    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        service.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
    }
}

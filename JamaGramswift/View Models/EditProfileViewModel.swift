//
//  EditProfileViewModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/30/23.
//

import Firebase
import SwiftUI
import PhotosUI

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(from: selectedImage)
            }
        }
    }
    @Published var profileImage: Image?
    @Published var username: String = ""
    @Published var name: String = ""
    @Published var bio: String = ""
    
    func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else {
            return
        }
        guard let data = try? await item.loadTransferable(type: Data.self) else {
            return
        }
        guard let uiImage = UIImage(data: data) else {
            return
        }
        self.profileImage = Image(uiImage: uiImage)
    }
}

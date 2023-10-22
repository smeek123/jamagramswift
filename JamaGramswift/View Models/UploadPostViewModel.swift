//
//  UploadPostViewModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 9/6/23.
//

import SwiftUI
import PhotosUI
import Firebase

@MainActor
class UploadPostViewModel: ObservableObject {
    @Published var selectedImage: PhotosPickerItem? {
        didSet {
            Task {
                await loadImage(from: selectedImage)
            }
        }
    }
    @Published var postImage: Image?
    private var uiImage: UIImage?
    
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
        
        self.uiImage = uiImage
        self.postImage = Image(uiImage: uiImage)
    }
    
    func uploadPost(caption: String, song: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        guard let uiImage = uiImage else {
            return
        }
        
        let postRef = Firestore.firestore().collection("posts").document()
        
        guard let imageUrl = try await ImageUploader.uploadImage(image: uiImage) else {
            return
        }
        
        let post = Post(id: postRef.documentID, songURI: song, ownerUid: uid, caption: caption, imageUrl: imageUrl, timeStamp: Timestamp(), likers: [])
        guard let encodedPost = try? Firestore.Encoder().encode(post) else {
            return
        }
        try await postRef.setData(encodedPost)
    }
}

//
//  ImageUploader.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/31/23.
//

import FirebaseStorage
import UIKit
import Firebase

struct ImageUploader {
    static func uploadImage(image: UIImage) async throws -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return nil
        }
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        do {
            let _ = try await ref.putDataAsync(imageData)
            let url = try await ref.downloadURL()
            return url.absoluteString
        } catch {
            print("failed to upload image with error: \(error.localizedDescription)")
            return nil
        }
    }
}

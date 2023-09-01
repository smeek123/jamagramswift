//
//  ProfileImageView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 9/1/23.
//

import SwiftUI
import Kingfisher

struct ProfileImageView: View {
    let user: FireUser
    let size: CGFloat
    
    var body: some View {
        if let imageUrl = user.profileImageURL {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .foregroundColor(.secondary)
        }
    }
}

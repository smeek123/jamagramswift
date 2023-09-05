//
//  ExpandedProfileView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 9/5/23.
//

import SwiftUI

struct ExpandedProfileView: View {
    let user: FireUser
    
    var body: some View {
        VStack(spacing: 15) {
            Spacer()
            
            ProfileImageView(user: user, size: 200)
            
            Text(user.username)
                .foregroundColor(.primary)
                .font(.title3)
            
            if user.name != nil {
                Text(user.name)
                    .foregroundColor(.secondary)
                    .font(.title3)
            }
            
            LargeButtonView(title: "Share")
            
            Spacer()
        }
    }
}

struct ExpandedProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ExpandedProfileView()
    }
}

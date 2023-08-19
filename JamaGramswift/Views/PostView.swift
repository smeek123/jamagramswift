//
//  PostView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/18/23.
//

import SwiftUI

struct PostView: View {
    @State private var like: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Image("profile-image")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                
                Text("Wendy")
                    .foregroundColor(.primary)
                    .font(.system(size: 15))
                
                Spacer()
                
                Text("6h ago")
                    .font(.footnote)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 18)
            .padding(.bottom, 8)
            
            Image("post-image")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width * 0.95)
                .clipShape(Rectangle())
            
            HStack(spacing: 15) {
                Button {
                    like.toggle()
                } label: {
                    Label {
                        Text("300")
                    } icon: {
                        if like {
                            Image(systemName: "hands.clap.fill")
                                .font(.system(size: 23))
                                .foregroundColor(Color("MainColor"))
                        } else {
                            Image(systemName: "hands.clap")
                                .font(.system(size: 23))
                        }
                    }
                    .font(.system(size: 20))
                    .foregroundColor(.primary)
                }
                
                Label {
                    Text("10")
                } icon: {
                    Image(systemName: "mic")
                }
                .font(.system(size: 20))
                .foregroundColor(.primary)
                
                Image(systemName: "headphones")
                    .font(.system(size: 23))
                
                Image(systemName: "opticaldisc")
                    .font(.system(size: 23))
                
                Image(systemName: "bookmark")
                    .font(.system(size: 23))
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack(alignment: .center) {
                Text("Wendy ")
                    .fontWeight(.bold) +
                Text("This song makes me want to run into the waves!!!")
                
                Spacer()
            }
            .padding(.leading, 10)
            .multilineTextAlignment(.leading)
            .lineLimit(3)
            .font(.system(size: 15))
            .padding(5)
            
            Divider()
                .overlay(Color("MainColor"))
                .padding(.vertical, 10)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}

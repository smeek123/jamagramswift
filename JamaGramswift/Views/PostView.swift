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
            Rectangle()
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width * 0.95, height: UIScreen.main.bounds.width * 0.95)
            
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
                
                Spacer()
            }
            .padding(.horizontal)
            
            HStack {
                Text("username, this is where a caption shows up.")
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .font(.system(size: 15))
                
                Spacer()
            }
            .padding(.horizontal)
        }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}

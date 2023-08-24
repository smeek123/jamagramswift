//
//  AddStreamingView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/23/23.
//

import SwiftUI

struct AddStreamingView: View {
    @Environment(\.dismiss) var dismiss
    let spotifyGradient = LinearGradient(
        gradient: Gradient(
            colors: [Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.1903857588, green: 0.8321116255, blue: 0.4365008013, alpha: 1))]
        ),
        startPoint: .leading, endPoint: .trailing
    )
    
    var body: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Text("Add a streaming account")
                .foregroundColor(.primary)
                .font(.title)
                .multilineTextAlignment(.center)
            
            Text("This will allow you to quickly share your favorite songs and artists.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .font(.headline)
            
            Button {
                
            } label: {
                HStack(spacing: 20) {
                    Image("White_Icon")
                        .interpolation(.high)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 40)
                    Text("Log in with Spotify")
                        .font(.title3)
                        .foregroundColor(.white)
                }
                .padding(.vertical, 8)
                .frame(width: UIScreen.main.bounds.width * 0.9)
                .background(spotifyGradient)
                .clipShape(Capsule())
            }
            
            Spacer()
            
            Button {
                
            } label: {
                LargeButtonView(title: "Skip")
            }
            .padding(.vertical)
            
            Text("4/4")
                .foregroundColor(.secondary)
                .font(.footnote)
                .fontWeight(.semibold)
                .padding(.vertical)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .font(.system(size: 20))
                }
            }
        }
    }
}


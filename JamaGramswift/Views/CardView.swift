//
//  CardView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/22/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardView: View {
    @State var track: track
    @State private var offset = CGSize.zero
    @StateObject var spotifyData = SpotifyDataManager()
    let spotifyGradient = LinearGradient(
        gradient: Gradient(
            colors: [Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.1903857588, green: 0.8321116255, blue: 0.4365008013, alpha: 1))]
        ),
        startPoint: .leading, endPoint: .trailing
    )
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 350, height: 500)
                .border(Color(UIColor.systemBackground), width: 10)
                .cornerRadius(10)
                .foregroundColor(.primary)
                .shadow(color: Color.primary.opacity(0.5), radius: 5)
            
            if spotifyData.isRetrievingData {
                ProgressView()
                    .foregroundColor(Color(UIColor.systemBackground))
            } else {
                VStack {
                    if let image = track.album.images.first?.url {
                        WebImage(url: URL(string: image) ?? URL(string: "")!)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 250, height: 250)
                            .padding()
                    }
                    
                    Text(track.name)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(UIColor.systemBackground))
                        .font(.title2)
                        .bold()
                        .frame(width: 300)
                    
                    Text(track.artists?.first?.name ?? "artist")
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0.75))
                        .font(.title3)
                        .frame(width: 300)
                    
                    Link(destination: URL(string: track.uri)!) {
                        HStack(spacing: 20) {
                            Image("White_Icon")
                                .interpolation(.high)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                                .padding(.vertical)
                            
                            Text("Listen on Spotify")
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                        }
                        .background(Capsule()
                            .fill(spotifyGradient)
                            .frame(width: 300))
                        .padding(10)
                    }
                }
            }
        }
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
            } .onEnded { _ in
                withAnimation {
                    swipeCard(width: offset.width)
                }
            }
        )
    }
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            offset = CGSize(width: -500, height: 0)
        case 150...500:
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
}


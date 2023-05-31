//
//  CardView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/22/23.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

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
    @State var player = AVPlayer()
    @State var isPlaying: Bool = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 350, height: 500)
                .border(Color(UIColor.systemBackground), width: 12)
                .cornerRadius(10)
                .shadow(color: Color.secondary.opacity(0.25), radius: 3)
                .foregroundColor(.primary)
            
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
                    .lineLimit(2)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .font(.title3)
                    .bold()
                    .frame(width: 300)
                
                Text(track.artists?.first?.name ?? "artist")
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0.75))
                    .font(.headline)
                    .frame(width: 300)
                
                if track.preview_url != nil {
                    HStack {
                        Spacer()
                        
                        Button {
                            if isPlaying {
                                isPlaying = false
                                player.pause()
                            } else {
                                isPlaying = true
                                player.play()
                            }
                        } label: {
                            HStack(spacing: 7) {
                                if isPlaying {
                                    Image(systemName: "pause.circle.fill")
                                        .foregroundColor(.primary)
                                        .font(.system(size: 35))
                                        .padding(.vertical, 10)
                                    
                                    Text("Pause")
                                        .font(.system(size: 16))
                                        .foregroundColor(.primary)
                                } else {
                                    Image(systemName: "play.circle.fill")
                                        .foregroundColor(.primary)
                                        .font(.system(size: 35))
                                        .padding(.vertical, 10)
                                    
                                    Text("Play")
                                        .font(.system(size: 18))
                                        .foregroundColor(.primary)
                                }
                            }
                            .onAppear {
                                if let url = URL(string: track.preview_url ?? "") {
                                    player = AVPlayer(playerItem: AVPlayerItem(url: url))
                                }
                            }
                            .background(Capsule()
                                .fill(Color(UIColor.systemBackground))
                                .frame(width: 125))
                            .padding(10)
                        }
                        
                        Spacer()
                        
                        Link(destination: URL(string: track.uri)!) {
                            HStack(spacing: 10) {
                                Image("White_Icon")
                                    .interpolation(.high)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(height: 40)
                                    .padding(.vertical, 10)
                                
                                Text("View")
                                    .font(.system(size: 18))
                                    .foregroundColor(.white)
                            }
                            .background(Capsule()
                                .fill(spotifyGradient)
                                .frame(width: 125))
                            .padding(10)
                        }
                        
                        Spacer()
                    }
                    .frame(width: 300)
                    .padding(8)
                } else {
                    Link(destination: URL(string: track.uri)!) {
                        HStack(spacing: 10) {
                            Image("White_Icon")
                                .interpolation(.high)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 25)
                                .padding(.vertical)
                            
                            Text("Listen on Spotify")
                                .font(.system(size: 18))
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
            player.pause()
            isPlaying = false
            player = AVPlayer()
        case 150...500:
            offset = CGSize(width: 500, height: 0)
            player.pause()
            isPlaying = false
            player = AVPlayer()
        default:
            offset = .zero
        }
    }
}


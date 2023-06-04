//
//  CardView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/22/23.
//

import SwiftUI
import SDWebImageSwiftUI
import AVKit

//this is the view that holds the code for the cards that can be swiped, a new song is passed into an instance of this view
struct CardView: View {
    //this holds the passed in track
    @State var track: track
    //this controls how much the card is dragged when being swiped
    @State private var offset = CGSize.zero
    //allows access to the functions in the data viewmodel
    @StateObject var spotifyData = SpotifyDataManager()
    //creates the link background
    let spotifyGradient = LinearGradient(
        gradient: Gradient(
            colors: [Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.1903857588, green: 0.8321116255, blue: 0.4365008013, alpha: 1))]
        ),
        startPoint: .leading, endPoint: .trailing
    )
    //variables to control the preview playing
    @State var player = AVPlayer()
    @State var isPlaying: Bool = false
    
    var body: some View {
        //a stack that allows objects to be on top of each in the Z direction
        ZStack {
            //the background of the card
            Rectangle()
                .frame(width: 350, height: 500)
                .border(Color(UIColor.systemBackground), width: 12)
                .cornerRadius(10)
                .shadow(color: Color.secondary.opacity(0.25), radius: 3)
                .foregroundColor(.primary)
            
            //sets up a vertical layout with the image, title, artist and play options
            VStack {
                //checks to see if the image url is valid
                if let image = track.album.images.first?.url {
                    //shows the image if valid with a web package
                    WebImage(url: URL(string: image) ?? URL(string: "")!)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .padding()
                }
                
                //displays the name of the track
                Text(track.name)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .font(.title3)
                    .bold()
                    .frame(width: 300)
                
                //shows the artists name
                Text(track.artists?.first?.name ?? "artist")
                    .lineLimit(1)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(UIColor.secondarySystemBackground).opacity(0.75))
                    .font(.headline)
                    .frame(width: 300)
                
                //check is a track has a preview url, not all do so it could be nil
                //a preview url is a 30 second sample of a song
                if track.preview_url != nil {
                    //if preview is not nil this give a play option and a link to the full song
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
                                //initializes a player object
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
                        
                        //creates a link to the full song on spotify
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
        //controls where the card is while being dragged
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        //allows the card to be dragged
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    offset = gesture.translation
                } .onEnded { _ in
                    withAnimation {
                        swipeCard(width: offset.width, track: track)
                    }
                }
        )
    }
    
    //this function controls the swipe action, it handles the disappearing of the card if fully swiped and it stops the track playing. I used the source "How to create card swipes in SwiftUI" to learn about this feature.
    func swipeCard(width: CGFloat, track: track) {
        //decides where the card will go when swiped
        switch width {
        case -500...(-150):
            offset = CGSize(width: -500, height: 0)
            player.pause()
            isPlaying = false
            player = AVPlayer()
        case 150...500:
            //in future I will add track to a playlist in this case
            offset = CGSize(width: 500, height: 0)
            player.pause()
            isPlaying = false
            player = AVPlayer()
        default:
            offset = .zero
        }
    }
}


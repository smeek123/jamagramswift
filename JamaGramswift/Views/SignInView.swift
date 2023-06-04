//
//  SignInView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/6/23.
//

import SwiftUI

//this is the first view that shows up asking you to connect to spotify
struct SignInView: View {
    //allows access to methods in the auth manager class
    @StateObject var spotify = SpotifyAuthManager()
    //gradient for the button
    let spotifyGradient = LinearGradient(
        gradient: Gradient(
            colors: [Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)), Color(#colorLiteral(red: 0.1903857588, green: 0.8321116255, blue: 0.4365008013, alpha: 1))]
        ),
        startPoint: .leading, endPoint: .trailing
    )
    
    var body: some View {
        ZStack {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            //shows a background image behing the main section
            VStack {
                Spacer()
                
                Image("Background")
                    .resizable()
                    .scaledToFill()
            }
            //makes the image a little darker
            .overlay {
                Color.black
                    .opacity(0.4)
            }
            
            VStack {
                Spacer()
                
                //shows welcome text
                Text("Welcome to\nJamaGram!")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                    .padding(20)
                
                //shows continue message
                Text("To continue, please connect to\nyour Spotify account.")
                    .foregroundColor(.white)
                    .padding(10)
                    .font(.title3)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                //sends user to the auth screen
                Link(destination: spotify.spotifyURL()) {
                    HStack(spacing: 20) {
                        Image("White_Icon")
                            .interpolation(.high)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 50)
                        
                        Text("Log in with Spotify")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    .background(Capsule()
                        .fill(spotifyGradient)
                        .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.1))
                    .padding(20)
                }
                .padding(.vertical)
                //this makes it so you cannot request a tokenuntil the previos one is done loading
                .allowsHitTesting(!SpotifyAM.isRetrievingTokens)
                
                Spacer()
            }
        }
    }
}



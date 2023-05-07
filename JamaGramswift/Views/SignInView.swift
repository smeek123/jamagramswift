//
//  SignInView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/6/23.
//

import SwiftUI

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
        //sends user to the auth screen
        Link(destination: spotify.spotifyURL()) {
            HStack(spacing: 20) {
                Text("Log in with Spotify")
                    .font(.system(size: 30))
            }
            .background(RoundedRectangle(cornerRadius: 15)
                .fill(spotifyGradient)
                .frame(width: UIScreen.main.bounds.width * 0.9, height: UIScreen.main.bounds.height * 0.1))
        }
        .accessibility(identifier: "Log in with Spotify Identifier")
        .padding(.vertical)
        .allowsHitTesting(!SpotifyAM.isRetrievingTokens)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView()
    }
}

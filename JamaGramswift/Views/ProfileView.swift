//
//  ProfileView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/12/23.
//

import SwiftUI
//this package helps show an image given by a url
import SDWebImageSwiftUI

struct ProfileView: View {
    @StateObject var SpotifyAM = SpotifyAuthManager()
    @State var showDelete: Bool = false;
    
    //This removes the tokens when logging out
    func logOut() {
        Task {
            do {
                try await SpotifyAuthManager.deleteToken(service: "spotify.com", accounr: "accessToken")
                
                try await SpotifyAuthManager.deleteToken(service: "spotify.com", accounr: "refreshToken")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        VStack {
            Button {
                showDelete = true
            } label: {
                Text("Remove Account")
                    .foregroundColor(.red)
                    .font(.title3)
            }
        }
        //presents a message to confirm the log out
        .confirmationDialog("Remove Account?", isPresented: $showDelete, titleVisibility: .visible) {
            Button(role: .cancel) {
                print("canceled")
            } label: {
                Text("cancel")
            }
            
            Button(role: .destructive) {
                logOut()
            } label: {
                Text("Remove")
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

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
    @AppStorage("signedIn") var isSignedIn: Bool = false
    @StateObject var SpotifyAM = SpotifyAuthManager()
    @StateObject var spotifyData = SpotifyDataManager()
    @State var currentUser: User? = nil
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
            if isSignedIn {
                if spotifyData.isRetrievingData {
                    Image(systemName: "person.circle")
                        .font(.system(size: 100))
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                        .padding()
                    
                } else {
                    //checks to make sure no value are nil
                    if let user = currentUser {
                        //checks that the url is not nil
                        if let image = user.images?.first?.url {
                            //takes the url and use the image package to show a circular image
                            WebImage(url: URL(string: image) ?? URL(string: "")!)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .padding()
                        } else {
                            Image(systemName: "person.circle")
                                .font(.system(size: 75))
                        }
                    }
                }
            }
            
            Spacer()
            
            Button {
                showDelete = true
            } label: {
                Text("Remove Account")
                    .foregroundColor(.primary)
                    .font(.title)
                    .padding(.horizontal)
            }
            .clipShape(Capsule())
            .buttonStyle(.bordered)
            .padding(20)
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
        //sets the current user = to the result of the get profile func
        .task {
            if isSignedIn {
                currentUser = try? await spotifyData.getProfile()
            }
            
            if SpotifyAuthManager.shouldRefresh {
                try? await SpotifyAuthManager.getRefreshedAccessToken()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

//
//  ProfileView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/12/23.
//

import SwiftUI
//this package helps show an image given by a url
import SDWebImageSwiftUI

//this shows the spotify image and username of the person signed in. It also allows for signing out.
struct ProfileView: View {
    //holds the value of issignedin in the device storage
    @AppStorage("signedIn") var isSignedIn: Bool = false
    @StateObject var SpotifyAM = SpotifyAuthManager()
    @StateObject var spotifyData = SpotifyDataManager()
    @State var currentUser: User? = nil
    @State var showDelete: Bool = false;
    
    //This removes the tokens when logging out
    func logOut() {
        Task {
            do {
                //any func that can throw and error has try in front
                try await SpotifyAuthManager.deleteToken(service: "spotify.com", accounr: "accessToken")
                
                try await SpotifyAuthManager.deleteToken(service: "spotify.com", accounr: "refreshToken")
            } catch {
                //prints any error that happens.
                print(error.localizedDescription)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    if isSignedIn {
                        //while data is loading a place holder is shown
                        if spotifyData.isRetrievingData {
                            VStack {
                                Image(systemName: "person.circle")
                                    .font(.system(size: 100))
                                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                                    .padding()
                            }
                        } else {
                            //checks to make sure no values are nil
                            if let user = currentUser {
                                //checks that the url is not nil
                                if let image = user.images?.first?.url {
                                    //takes the url and use the image package to show a circular image
                                    VStack {
                                        WebImage(url: URL(string: image) ?? URL(string: "")!)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                            .padding()
                                    }
                                } else {
                                    //if image is nil, place holder is shown
                                    Image(systemName: "person.circle")
                                        .font(.system(size: 75))
                                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                                }
                                
                                if !spotifyData.isRetrievingData {
                                    //when data loads, username is shown
                                    Text(user.display_name)
                                        .foregroundColor(.primary)
                                        .font(.title)
                                } else {
                                    Text("username")
                                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                                        .font(.title)
                                }
                            }
                        }
                    }
                    
                    NavigationLink(destination: {
                        Text("streaming platform")
                    }, label: {
                        HStack {
                            Image(systemName: "headphones")
                                .foregroundColor(.primary)
                                .font(.largeTitle)
                            
                            Text("Streaming Platform")
                                .foregroundColor(.primary)
                                .font(.title3)
                                .padding(.horizontal, 15)
                            
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 75)
                        .padding(.horizontal, 15)
                    })
                    .clipShape(Capsule())
                    .buttonStyle(.bordered)
                    .padding(10)
                    
                    Button {
                        showDelete = true
                    } label: {
                        HStack {
                            Image(systemName: "arrowshape.backward")
                                .foregroundColor(.primary)
                                .font(.largeTitle)
                            
                            Text("Log Out")
                                .foregroundColor(.primary)
                                .font(.title3)
                                .padding(.horizontal, 15)
                            
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 75)
                        .padding(.horizontal, 15)
                    }
                    .clipShape(Capsule())
                    .buttonStyle(.bordered)
                    .padding(10)
                    
                    Button {
                        showDelete = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                                .foregroundColor(.primary)
                                .font(.largeTitle)
                            
                            Text("Delete Account")
                                .foregroundColor(.primary)
                                .font(.title3)
                                .padding(.horizontal, 15)
                            
                            Spacer()
                        }
                        .frame(width: UIScreen.main.bounds.width * 0.8, height: 75)
                        .padding(.horizontal, 15)
                    }
                    .clipShape(Capsule())
                    .buttonStyle(.bordered)
                    .padding(10)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("JamaGram")
                        .foregroundColor(.primary)
                        .font(.system(size: 25))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        Text("Notifications")
                    } label: {
                        Image(systemName: "bell")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        Text("Messages")
                    } label: {
                        Image(systemName: "message")
                            .foregroundColor(.primary)
                            .font(.system(size: 20))
                    }
                }
            }
            //presents a message to confirm the log out
            .confirmationDialog("Remove Account?", isPresented: $showDelete, titleVisibility: .visible) {
                //cancels the action
                Button(role: .cancel) {
                    print("canceled")
                } label: {
                    Text("cancel")
                }
                
                //calls the logout method and deletes the access token and account.
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
            }
        }
    }
}

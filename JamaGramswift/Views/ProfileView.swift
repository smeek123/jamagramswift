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
    @AppStorage("signedIn") var isSignedIn: Bool = false
    @StateObject var SpotifyAM = SpotifyAuthManager()
    @StateObject var spotifyData = SpotifyDataManager()
    @State var currentUser: User? = nil
    @State var topArtist: topArtistModel? = nil
    @State var topTrack: topTrackModel? = nil
    @State var showDelete: Bool = false
    @State var showSignOut: Bool = false
    @State private var selection: Int = 0
    @Namespace private var pickerTabs
    let user: FireUser
    @Environment(\.dismiss) var dismiss
    @State private var showEditView: Bool = false
    
    //This removes the tokens when logging out
    func logOutSpotify() {
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
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(Color("MainColor"), lineWidth: 3)
                            .frame(width: 100, height: 100)
                        
                        VStack(spacing: 7) {
                            Text("12.3M")
                                .foregroundColor(.primary)
                                .font(.system(size: 18))
                            
                            Text("Followers")
                                .foregroundColor(.primary)
                                .font(.system(size: 17))
                        }
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "person.circle")
                            .font(.system(size: 100))
                            .foregroundColor(.primary)
                            .padding()
                        
                        Text(user.username)
                            .foregroundColor(.primary)
                            .font(.title)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .stroke(Color("MainColor"), lineWidth: 3)
                            .frame(width: 100, height: 100)
                        
                        VStack(spacing: 7) {
                            Text("1.3K")
                                .foregroundColor(.primary)
                                .font(.system(size: 18))
                            
                            Text("Following")
                                .foregroundColor(.primary)
                                .font(.system(size: 17))
                        }
                    }
                    
                    Spacer()
                }
                
                Text(user.bio ?? "")
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 50)
                
                Button {
                    if user.isCurrentUser {
                        showEditView.toggle()
                    } else {
                        print("followed")
                    }
                } label: {
                    LargeButtonView(title: user.isCurrentUser ? "CustomIze" : "Follow")
                        .padding(.vertical, 8)
                }
                
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation(.linear) {
                            selection = 0
                        }
                    } label: {
                        ZStack {
                            if selection == 0 {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color("MainColor"))
                                    .matchedGeometryEffect(id: "tabs", in: pickerTabs)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                            }
                            
                            Image(systemName: "headphones")
                                .foregroundColor(.primary)
                                .font(.system(size: 22))
                                .padding(10)
                                .padding(.horizontal, 10)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.linear) {
                            selection = 1
                        }
                    } label: {
                        ZStack {
                            if selection == 1 {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color("MainColor"))
                                    .matchedGeometryEffect(id: "tabs", in: pickerTabs)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                            }
                            
                            Image(systemName: "star.fill")
                                .foregroundColor(.primary)
                                .font(.system(size: 22))
                                .padding(10)
                                .padding(.horizontal, 10)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
                .background(Color(UIColor.secondarySystemBackground))
                .clipShape(Capsule())
                .padding()
                
                if selection == 0 {
                    posts
                        .transition(.slide)
                } else if selection == 1 {
                    favorites
                        .transition(.slide)
                }
            }
            .fullScreenCover(isPresented: $showEditView) {
                EditProfileView(user: user)
            }
        }
        .navigationBarTitle(user.name ?? "JamaGram")
        .navigationBarTitleDisplayMode(.inline)
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
        //sets the current user = to the result of the get profile func
        .task {
            if isSignedIn {
                currentUser = try? await spotifyData.getProfile()
            }
        }
    }
    
    var favorites: some View {
        HStack {
            Spacer()
            
            VStack {
                if spotifyData.isRetrievingData {
                    Circle()
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                } else {
                    if let artist = topArtist {
                        if let image = artist.items.first?.images?.first?.url {
                            VStack {
                                Link(destination: URL(string: artist.items.first?.uri ?? "spotify:") ?? URL(string: "")!) {
                                    WebImage(url: URL(string: image) ?? URL(string: "")!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .clipShape(Circle())
                                        .padding()
                                }
                            }
                        } else {
                            Circle()
                                .frame(width: 150, height: 150)
                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                        }
                        
                        if !spotifyData.isRetrievingData {
                            Text(artist.items.first?.name ?? "artist")
                                .foregroundColor(.primary)
                                .font(.headline)
                        } else {
                            Capsule()
                                .frame(width: 100)
                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                        }
                    }
                }
            }
            
            Spacer()
            
            VStack {
                if spotifyData.isRetrievingData {
                    Rectangle()
                        .frame(width: 150, height: 150)
                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                } else {
                    if let track = topTrack {
                        if let image = track.items.first?.album.images.first?.url {
                            VStack {
                                Link(destination: URL(string: track.items.first?.uri ?? "") ?? URL(string: "spotify:")!) {
                                    WebImage(url: URL(string: image) ?? URL(string: "")!)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 150, height: 150)
                                        .padding()
                                }
                            }
                        } else {
                            Rectangle()
                                .frame(width: 150, height: 150)
                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                        }
                        
                        if !spotifyData.isRetrievingData {
                            Text(track.items.first?.name ?? "Track")
                                .foregroundColor(.primary)
                                .font(.headline)
                        } else {
                            Capsule()
                                .frame(width: 100)
                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                        }
                    }
                }
            }
            
            Spacer()
        }
        .task {
            if isSignedIn {
                topArtist = try? await spotifyData.getTopArtist()
                
                topTrack = try? await spotifyData.getTopTrack()
            }
        }
    }
    
    var posts: some View {
        VStack(spacing: 20) {
            Spacer()
            
            NavigationLink {
                CreateView()
            } label: {
                Image(systemName: "music.note.list")
                    .font(.system(size: 100))
                    .foregroundColor(.secondary)
            }
            
            Text("No posts yet.")
                .foregroundColor(.primary)
            
            Spacer()
        }
    }
}

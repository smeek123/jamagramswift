//
//  CurrentProfileView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/30/23.
//

import SwiftUI
import Kingfisher

struct CurrentProfileView: View {
    @AppStorage("signedIn") var isSignedIn: Bool = false
    //    @StateObject var SpotifyAM = SpotifyAuthManager()
    //    @StateObject var spotifyData = SpotifyDataManager()
    @State var currentUser: User? = nil
    @State var topArtist: topArtistModel? = nil
    @State var topTrack: topTrackModel? = nil
    @State var showDelete: Bool = false
    @State var showSignOut: Bool = false
    @State private var selection: Int = 0
    @Namespace private var pickerTabs
    let user: FireUser
    @Namespace var profileAnimation
    @State private var showExpanded: Bool = false
    @State private var showCreate: Bool = false
    @StateObject var viewModel = FeedViewModel()
    @StateObject var userPostViewModel: UserPostsViewModel
    
    init(user: FireUser) {
        self.user = user
        
        self._userPostViewModel = StateObject(wrappedValue: UserPostsViewModel(user: user))
    }
    
    private let gridItem: [GridItem] = [
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1),
        .init(.flexible(), spacing: 1)
    ]
    
    private let imageSize: CGFloat = (UIScreen.main.bounds.width / 3) - 1
    
    //This removes the tokens when logging out
    //    func logOutSpotify() {
    //        Task {
    //            do {
    //                //any func that can throw and error has try in front
    //                try await SpotifyAuthManager.deleteToken(service: "spotify.com", accounr: "accessToken")
    //
    //                try await SpotifyAuthManager.deleteToken(service: "spotify.com", accounr: "refreshToken")
    //            } catch {
    //                //prints any error that happens.
    //                print(error.localizedDescription)
    //            }
    //        }
    //    }
    
    var body: some View {
        NavigationStack {
            if showExpanded {
                expandedProfile
            } else {
                ScrollView(showsIndicators: false) {
                    VStack {
                        HStack {
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .stroke(Color("MainColor"), lineWidth: 3)
                                    .frame(width: 100, height: 100)
                                
                                VStack(spacing: 7) {
                                    Text(Int(9990000).asFormattedString)
                                        .foregroundColor(.primary)
                                        .font(.system(size: 18))
                                    
                                    Text("Followers")
                                        .foregroundColor(.primary)
                                        .font(.system(size: 17))
                                }
                            }
                            
                            Spacer()
                            
                            VStack {
                                ProfileImageView(user: user, size: 100)
                                    .matchedGeometryEffect(id: "image", in: profileAnimation)
                                    .onTapGesture {
                                        withAnimation(.spring()) {
                                            showExpanded.toggle()
                                        }
                                    }
                                
                                Text(user.username)
                                    .foregroundColor(.primary)
                                    .font(.title)
                                    .matchedGeometryEffect(id: "username", in: profileAnimation)
                            }
                            
                            Spacer()
                            
                            ZStack {
                                Circle()
                                    .stroke(Color("MainColor"), lineWidth: 3)
                                    .frame(width: 100, height: 100)
                                
                                VStack(spacing: 7) {
                                    Text(Int(1255).asFormattedString)
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
                            .padding(.bottom, 8)
                            .padding(.horizontal, 50)
                        
                        NavigationLink(destination: {
                            EditProfileView(user: user)
                                .navigationBarBackButtonHidden()
                        }, label: {
                            LargeButtonView(title: "Customize", isActive: true)
                                .padding(.vertical, 8)
                        })
                        
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
                            
                            Button {
                                withAnimation(.linear) {
                                    selection = 2
                                }
                            } label: {
                                ZStack {
                                    if selection == 2 {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(Color("MainColor"))
                                            .matchedGeometryEffect(id: "tabs", in: pickerTabs)
                                    } else {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                                    }
                                    
                                    Image(systemName: "bookmark.fill")
                                        .foregroundColor(.primary)
                                        .font(.system(size: 22))
                                        .padding(10)
                                        .padding(.horizontal, 10)
                                }
                            }
                            
                            Spacer()
                            
                            Button {
                                withAnimation(.linear) {
                                    selection = 3
                                }
                            } label: {
                                ZStack {
                                    if selection == 3 {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(Color("MainColor"))
                                            .matchedGeometryEffect(id: "tabs", in: pickerTabs)
                                    } else {
                                        RoundedRectangle(cornerRadius: 15)
                                            .foregroundColor(Color(UIColor.secondarySystemBackground))
                                    }
                                    
                                    Image(systemName: "gearshape.fill")
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
                            UserPostsView(user: user)
                                .transition(.slide)
                        } else if selection == 1 {
                            favorites
                                .transition(.slide)
                        } else if selection == 2 {
                            saves
                                .transition(.slide)
                        } else if selection == 3 {
                            settings
                                .transition(.slide)
                        }
                    }
                    .fullScreenCover(isPresented: $showCreate) {
                        CreateView()
                    }
                }
                .padding(.vertical)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Text(user.name ?? "JamaGram")
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
                        Button {
                            showCreate.toggle()
                        } label: {
                            Image(systemName: "plus.app")
                                .foregroundColor(.primary)
                                .font(.system(size: 20))
                        }
                    }
                    
                    //                ToolbarItem(placement: .navigationBarTrailing) {
                    //                    NavigationLink {
                    //                        Text("Messages")
                    //                    } label: {
                    //                        Image(systemName: "message")
                    //                            .foregroundColor(.primary)
                    //                            .font(.system(size: 20))
                    //                    }
                    //                }
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
                        
                    } label: {
                        Text("Remove")
                    }
                }
            }
        }
    }
    
    var settings: some View {
        VStack {
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
            
            NavigationLink(destination: {
                Text("privacy")
            }, label: {
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.primary)
                        .font(.largeTitle)
                    
                    Text("Privacy")
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
            
            NavigationLink(destination: {
                Text("Request a feature")
            }, label: {
                HStack {
                    Image(systemName: "plus")
                        .foregroundColor(.primary)
                        .font(.largeTitle)
                    
                    Text("Request a feature")
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
                showSignOut = true
            } label: {
                HStack {
                    Image(systemName: "arrowshape.backward")
                        .foregroundColor(.primary)
                        .font(.largeTitle)
                    
                    Text("Sign Out")
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
            .confirmationDialog("Sign Out?", isPresented: $showSignOut, titleVisibility: .visible) {
                //cancels the action
                Button(role: .cancel) {
                    print("canceled")
                } label: {
                    Text("cancel")
                }
                
                //calls the logout method and deletes the access token and account.
                Button(role: .destructive) {
                    UserAuthService.shared.signout()
                } label: {
                    Text("Sign out")
                }
            }
            
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
    
    var favorites: some View {
        HStack {
            Spacer()
            
            VStack {
                //                if spotifyData.isRetrievingData {
                //                    Circle()
                //                        .frame(width: 150, height: 150)
                //                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                //                } else {
                //                    if let artist = topArtist {
                //                        if let image = artist.items.first?.images?.first?.url {
                //                            VStack {
                //                                Link(destination: URL(string: artist.items.first?.uri ?? "spotify:") ?? URL(string: "")!) {
                //                                    KFImage(URL(string: image))
                //                                        .resizable()
                //                                        .scaledToFit()
                //                                        .frame(width: 150, height: 150)
                //                                        .clipShape(Circle())
                //                                        .padding()
                //                                }
                //                            }
                //                        } else {
                //                            Circle()
                //                                .frame(width: 150, height: 150)
                //                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                //                        }
                //
                //                        if !spotifyData.isRetrievingData {
                //                            Text(artist.items.first?.name ?? "artist")
                //                                .foregroundColor(.primary)
                //                                .font(.headline)
                //                        } else {
                //                            Capsule()
                //                                .frame(width: 100)
                //                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                //                        }
                //                    }
                //                }
            }
            
            Spacer()
            
            VStack {
                //                if spotifyData.isRetrievingData {
                //                    Rectangle()
                //                        .frame(width: 150, height: 150)
                //                        .foregroundColor(Color(UIColor.secondarySystemBackground))
                //                } else {
                //                    if let track = topTrack {
                //                        if let image = track.items.first?.album.images.first?.url {
                //                            VStack {
                //                                Link(destination: URL(string: track.items.first?.uri ?? "") ?? URL(string: "spotify:")!) {
                //                                    KFImage(URL(string: image))
                //                                        .resizable()
                //                                        .scaledToFit()
                //                                        .frame(width: 150, height: 150)
                //                                        .padding()
                //                                }
                //                            }
                //                        } else {
                //                            Rectangle()
                //                                .frame(width: 150, height: 150)
                //                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                //                        }
                //
                //                        if !spotifyData.isRetrievingData {
                //                            Text(track.items.first?.name ?? "Track")
                //                                .foregroundColor(.primary)
                //                                .font(.headline)
                //                        } else {
                //                            Capsule()
                //                                .frame(width: 100)
                //                                .foregroundColor(Color(UIColor.secondarySystemBackground))
                //                        }
                //                    }
                //                }
            }
            
            Spacer()
        }
        //        .task {
        //            if isSignedIn {
        //                topArtist = try? await spotifyData.getTopArtist()
        //
        //                topTrack = try? await spotifyData.getTopTrack()
        //            }
        //        }
    }
    
    var saves: some View {
        VStack {
            if userPostViewModel.savedPosts.isEmpty {
                ContentUnavailableView {
                    Image(systemName: "bookmark")
                        .font(.system(size: 100))
                } description: {
                    Text("Nothing saved yet.")
                        .fontWeight(.semibold)
                }
            } else {
                LazyVGrid(columns: gridItem, spacing: 1) {
                    ForEach(userPostViewModel.savedPosts) { post in
                        KFImage(URL(string: post.imageUrl))
                            .resizable()
                            .scaledToFill()
                            .frame(width: imageSize, height: imageSize)
                            .clipped()
                            .contextMenu {
                                Button(role: .destructive) {
                                    Task {
                                        try? await viewModel.removeSavedPost(postId: post.id)
                                    }
                                } label: {
                                    Label("Remove", systemImage: "bookmark.fill")
                                }
                                
                                if let user = post.user {
                                    if !user.isCurrentUser {
                                        Button(role: .destructive) {
                                            
                                        } label: {
                                            Label("Report", systemImage: "exclamationmark.bubble")
                                        }
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
    
    var expandedProfile: some View {
        ZStack {
            Color(UIColor.secondarySystemBackground).ignoresSafeArea()
            
            VStack(spacing: 10) {
                Spacer()
                
                ProfileImageView(user: user, size: 200)
                    .matchedGeometryEffect(id: "image", in: profileAnimation)
                    .padding(.vertical)
                
                Text(user.username)
                    .foregroundColor(.primary)
                    .font(.title)
                    .matchedGeometryEffect(id: "username", in: profileAnimation)
                
                if user.name != nil {
                    Text(user.name ?? "")
                        .foregroundColor(.secondary)
                        .font(.title)
                }
                
                Spacer()
                
                LargeButtonView(title: "Share", isActive: true)
                
                Spacer()
            }
        }
        .onTapGesture {
            withAnimation(.spring()) {
                showExpanded.toggle()
            }
        }
    }
}

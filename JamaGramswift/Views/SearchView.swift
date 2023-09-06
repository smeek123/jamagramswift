//
//  SearchView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 7/15/23.
//

import SwiftUI

struct SearchView: View {
    @State private var search: String = ""
    @State private var tab: Int = 0
    @State private var searchPrompt: String = "Search for friends"
    @Namespace private var pickerTabs
    @StateObject var viewModel = SearchViewModel()
    @State private var showCreate: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                HStack {
                    Spacer()
                    
                    Button {
                        withAnimation(.linear) {
                            tab = 0
                            searchPrompt = "Search for friends"
                        }
                    } label: {
                        ZStack {
                            if tab == 0 {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color("MainColor"))
                                    .matchedGeometryEffect(id: "tabs", in: pickerTabs)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                            }
                            
                            Text("Users")
                                .foregroundColor(.primary)
                                .font(.system(size: 20))
                                .padding(10)
                                .padding(.horizontal, 10)
                        }
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.linear) {
                            tab = 1
                            searchPrompt = "Search by track name"
                        }
                    } label: {
                        ZStack {
                            if tab == 1 {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color("MainColor"))
                                    .matchedGeometryEffect(id: "tabs", in: pickerTabs)
                            } else {
                                RoundedRectangle(cornerRadius: 15)
                                    .foregroundColor(Color(UIColor.secondarySystemBackground))
                            }
                            
                            Text("Posts")
                                .foregroundColor(.primary)
                                .font(.system(size: 20))
                                .padding(10)
                                .padding(.horizontal, 10)
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 10)
                
                LazyVStack(spacing: 24) {
                    ForEach(viewModel.users) { user in
                        NavigationLink(value: user) {
                            HStack {
                                ProfileImageView(user: user, size: 60)
                                
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(user.username)
                                        .foregroundColor(.primary)
                                        .font(.subheadline)
                                    
                                    if user.name != nil {
                                        Text(user.name ?? "")
                                            .foregroundColor(.secondary)
                                            .font(.subheadline)
                                    }
                                }
                                .padding(.leading, 5)
                                
                                Spacer()
                                
                                Button {
                                    print("followed")
                                } label: {
                                    Text("Follow")
                                        .font(.system(size: 15))
                                        .foregroundColor(.primary)
                                }
                                .buttonBorderShape(.capsule)
                                .buttonStyle(.borderedProminent)
                                .tint(Color("MainColor"))
                            }
                            .padding(.horizontal, 5)
                        }

                    }
                }
                .navigationDestination(for: FireUser.self, destination: { user in
                    ProfileView(user: user)
                        .navigationBarBackButtonHidden()
                })
                .searchable(text: $search, prompt: searchPrompt)
                .padding(.vertical, 25)
                .padding(.horizontal)
                .fullScreenCover(isPresented: $showCreate) {
                    CreateView()
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
            .padding(.vertical)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

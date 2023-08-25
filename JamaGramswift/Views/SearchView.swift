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
                        Text("Users")
                            .foregroundColor(.primary)
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: 45)
                            .background(tab == 0 ? Color("MainColor") : Color(uiColor: .secondarySystemBackground))
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                    
                    Button {
                        withAnimation(.linear) {
                            tab = 1
                            searchPrompt = "Search by track name"
                        }
                    } label: {
                        Text("Posts")
                            .foregroundColor(.primary)
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: 45)
                            .background(tab == 1 ? Color("MainColor") : Color(uiColor: .secondarySystemBackground))
                            .clipShape(Capsule())
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 18)
                
                LazyVStack(spacing: 24) {
                    ForEach(0..<100) { user in
                        HStack {
                            Image("profile-image")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                            
                            Text("Wendy")
                                .foregroundColor(.primary)
                                .font(.system(size: 15))
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Text("Follow")
                                    .font(.system(size: 15))
                                    .foregroundColor(.primary)
                            }
                            .buttonBorderShape(.capsule)
                            .buttonStyle(.borderedProminent)
                            .tint(Color("MainColor"))
                        }
                        .padding(.horizontal, 18)
                    }
                }
                .searchable(text: $search, prompt: searchPrompt)
                .padding(.vertical, 25)
                .padding(.horizontal)
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
                        CreateView()
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
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

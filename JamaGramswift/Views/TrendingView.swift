//
//  TrendingView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 7/15/23.
//

import SwiftUI

struct TrendingView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("Top Artists")
                            .foregroundColor(.primary)
                            .font(.system(size: 30))
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 30) {
                            ForEach(0..<10, id: \.self) { artist in
                                VStack(spacing: 10) {
                                    Circle()
                                        .frame(width: 100, height: 100)
                                    
                                    Text(String(artist))
                                        .foregroundColor(.primary)
                                        .font(.system(size: 15))
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                    }
                }
                
                VStack {
                    HStack {
                        Text("Top Tracks")
                            .foregroundColor(.primary)
                            .font(.system(size: 30))
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 30) {
                            ForEach(0..<10, id: \.self) { artist in
                                VStack(spacing: 10) {
                                    Rectangle()
                                        .frame(width: 100, height: 100)
                                    
                                    Text(String(artist))
                                        .foregroundColor(.primary)
                                        .font(.system(size: 15))
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                    }
                }
                .padding(.vertical, 10)
                
                VStack {
                    HStack {
                        Text("Top Posts")
                            .foregroundColor(.primary)
                            .font(.system(size: 30))
                        
                        Spacer()
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 18)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 30) {
                            ForEach(0..<10, id: \.self) { artist in
                                VStack(spacing: 10) {
                                    Rectangle()
                                        .frame(width: 100, height: 100)
                                    
                                    Text(String(artist))
                                        .foregroundColor(.primary)
                                        .font(.system(size: 15))
                                        .lineLimit(1)
                                }
                            }
                        }
                        .padding(.horizontal, 18)
                    }
                }
                .padding(.vertical, 10)
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
        }
    }
}

struct TrendingView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingView()
    }
}

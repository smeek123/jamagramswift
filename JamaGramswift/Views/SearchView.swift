//
//  SearchView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 7/15/23.
//

import SwiftUI

struct SearchView: View {
    @State private var search: String = ""
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                List {
                    Text("10000")
                    Text("10000")
                    Text("10000")
                    Text("10000")
                    Text("10000")
                    Text("10000")
                    Text("10000")
                    Text("10000")
                    Text("10000")
                }
                .searchable(text: $search, prompt: "Search for friends or tracks")
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

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

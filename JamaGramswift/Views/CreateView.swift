//
//  CreateView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 7/15/23.
//

import SwiftUI

struct CreateView: View {
    var body: some View {
        NavigationStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
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

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}

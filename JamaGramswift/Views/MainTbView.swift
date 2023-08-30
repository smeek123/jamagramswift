//
//  MainTbView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 8/29/23.
//

import SwiftUI

struct MainTabView: View {
    let user: FireUser
    @State private var selection: Int = 0
    
    var body: some View {
        VStack {
            TabView(selection: $selection) {
                HomeView()
                    .tabItem {
                        if selection == 0 {
                            Image(systemName: "house.fill")
                        } else {
                            Image(systemName: "house")
                                .environment(\.symbolVariants, .none)
                        }
                    }.tag(0)
                
                SearchView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }.tag(1)
                
                CurrentProfileView(user: user)
                    .tabItem {
                        if selection == 4 {
                            Image(systemName: "person.circle.fill")
                        } else {
                            Image(systemName: "person.circle")
                                .environment(\.symbolVariants, .none)
                        }
                    }.tag(2)
            }
        }
        .accentColor(.primary)
    }
}

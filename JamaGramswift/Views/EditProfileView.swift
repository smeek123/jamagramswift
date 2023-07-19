//
//  EditProfileView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 7/19/23.
//

import SwiftUI

struct EditProfileView: View {
    @State private var username: String = ""
    @State private var name: String = ""
    @State private var bio: String = ""
    @State private var birthday: Date = Date()
    
    var body: some View {
        VStack {
            VStack(spacing: 15) {
                Section(header: HStack {
                    Text("Username")
                    
                    Spacer()
                }) {
                    TextField("Username", text: $username)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 40)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(Capsule())
                }
                
                Section(header: HStack {
                    Text("Name")
                    
                    Spacer()
                }) {
                    TextField("Name", text: $name)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 40)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(Capsule())
                }
                
                Section(header: HStack {
                    Text("Bio")
                    
                    Spacer()
                }) {
                    TextField("Bio", text: $bio)
                        .padding()
                        .frame(width: UIScreen.main.bounds.width * 0.95, height: 40)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .clipShape(Capsule())
                }
            }
            .padding()
            
            Spacer()
        }
        .navigationTitle("Customize")
    }
}

//
//  EditProfileView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 7/19/23.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @State private var username: String = ""
    @State private var name: String = ""
    @State private var bio: String = ""
    @State private var birthday: Date = Date()
    @State private var selectedImage: Image? = nil
    @State private var imageSelection: PhotosPickerItem? = nil
    @State private var startingDate: Date = Date().addingTimeInterval(-3564259200)
    @State private var endDate: Date = Date().addingTimeInterval(-410228000)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack(spacing: 15) {
                    PhotosPicker(selection: $imageSelection, matching: .images) {
                        if selectedImage != nil {
                            selectedImage!
                                .resizable()
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 100, height: 100)
                        }
                    }
                    .onChange(of: imageSelection) { _ in
                        Task {
                            if let data = try? await imageSelection?.loadTransferable(type: Data.self) {
                                if let uiImage = UIImage(data: data) {
                                    selectedImage = Image(uiImage: uiImage)
                                    return
                                }
                            }
                        }
                    }
                    
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
                    
                    Section(header: HStack {
                        Text("Birthday")
                        
                        Spacer()
                    }) {
                        DatePicker("Birthday", selection: $birthday, in: startingDate...endDate, displayedComponents: .date)
                            .padding()
                            .frame(width: UIScreen.main.bounds.width * 0.95, height: 40)
                            .background(Color(uiColor: .secondarySystemBackground))
                            .clipShape(Capsule())
                    }
                }
                .padding()
                
                Spacer()
                
                Button {
                    
                } label: {
                    HStack {
                        Spacer()
                        
                        Text("Save")
                            .foregroundColor(.primary)
                            .font(.title3)
                            .padding(.horizontal, 15)
                        
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8, height: 25)
                    .padding(.horizontal, 15)
                }
                .background(Color("MainColor"))
                .clipShape(Capsule())
                .buttonStyle(.bordered)
                .padding(10)
                .padding(.vertical)
            }
        }
        .navigationTitle("Customize")
    }
}

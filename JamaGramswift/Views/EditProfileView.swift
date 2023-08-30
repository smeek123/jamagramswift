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
    @Environment(\.dismiss) var dismiss
    
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
                            .modifier(TextFieldModifier())
                    }
                    
                    Section(header: HStack {
                        Text("Name")
                        
                        Spacer()
                    }) {
                        TextField("Name", text: $name)
                            .modifier(TextFieldModifier())
                    }
                    
                    Section(header: HStack {
                        Text("Bio")
                        
                        Spacer()
                    }) {
                        TextField("Bio", text: $bio)
                            .modifier(TextFieldModifier())
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
                    LargeButtonView(title: "Save")
                }
            }
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
        }
        .navigationTitle("Customize")
    }
}

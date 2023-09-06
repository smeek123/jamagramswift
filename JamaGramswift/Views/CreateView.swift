//
//  CreateView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 7/15/23.
//

import SwiftUI

struct CreateView: View {
    @Environment(\.dismiss) var dismiss
    @State private var song: String = ""
    @State private var caption: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.primary)
                        .font(.system(size: 20))
                }
                
                Spacer()
                
                Text("Customize")
                    .font(.subheadline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button {
                    
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundColor(.primary)
                        .font(.system(size: 20))
                }
            }
            .padding(.horizontal)
            .padding()
            
            Image("post-image")
                .resizable()
                .scaledToFill()
                .frame(width: 300, height: 300)
                .clipped()
                .padding()
            
            TextField("Search by track name", text: $song)
                .modifier(TextFieldModifier())
            
            TextField("Add a caption", text: $caption, axis: .vertical)
                .lineLimit(5)
                .modifier(TextFieldModifier())
            
            Spacer()
        }
    }
}

struct CreateView_Previews: PreviewProvider {
    static var previews: some View {
        CreateView()
    }
}

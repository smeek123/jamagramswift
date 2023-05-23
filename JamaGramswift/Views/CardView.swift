//
//  CardView.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/22/23.
//

import SwiftUI

struct CardView: View {
    @State var track: String
    @State private var offset = CGSize.zero
    
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 350, height: 500)
                .border(Color(UIColor.systemBackground), width: 10)
                .cornerRadius(10)
                .foregroundColor(.primary)
                .shadow(color: Color.primary.opacity(0.5), radius: 5)
            
            HStack {
                Text(track)
                    .foregroundColor(Color(UIColor.systemBackground))
                    .font(.largeTitle)
                    .bold()
            }
        }
        .offset(x: offset.width, y: offset.height * 0.4)
        .rotationEffect(.degrees(Double(offset.width / 40)))
        .gesture(
            DragGesture()
            .onChanged { gesture in
                offset = gesture.translation
            } .onEnded { _ in
                withAnimation {
                    swipeCard(width: offset.width)
                }
            }
        )
    }
    
    func swipeCard(width: CGFloat) {
        switch width {
        case -500...(-150):
            offset = CGSize(width: -500, height: 0)
        case 150...500:
            offset = CGSize(width: 500, height: 0)
        default:
            offset = .zero
        }
    }
}


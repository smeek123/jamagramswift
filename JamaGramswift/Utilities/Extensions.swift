//
//  Extensions.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/6/23.
//

import Foundation
import SwiftUI

//this extension allows a date to be saved in the devices app storage which is used in the login process 
extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
     
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.95, height: 40)
            .background(Color(uiColor: .secondarySystemBackground))
            .clipShape(Capsule())
    }
}

struct LargeButtonView: View {
    let title: String
    
    var body: some View {
        HStack {
            Spacer()
            
            Text(title)
                .foregroundColor(.primary)
                .font(.title3)
                .padding(.horizontal, 15)
                .lineLimit(2)
                .minimumScaleFactor(0.8)
            
            Spacer()
        }
        .frame(width: UIScreen.main.bounds.width * 0.85, height: 35)
        .padding(.horizontal, 15)
        .background(Color("MainColor"))
        .clipShape(Capsule())
    }
}

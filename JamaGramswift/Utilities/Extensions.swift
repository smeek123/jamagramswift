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
    
    func timeAgo() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}

extension Double {
    func reduceScale(to places: Int) -> Double {
        let multiplier = pow(10, Double(places))
        let newDecimal = multiplier * self // move the decimal right
        let truncated = Double(Int(newDecimal)) // drop the fraction
        let originalDecimal = truncated / multiplier // move the decimal back
        return originalDecimal
    }
}

extension Int {
    var asFormattedString: String {
        let num = abs(Double(self))

        switch num {
        case 1_000_000_000...:
            return "\((num / 1_000_000_000).reduceScale(to: 1))B"
        case 1_000_000...:
            return "\((num / 1_000_000).reduceScale(to: 1))M"
        case 1_000...:
            return "\((num / 1_000).reduceScale(to: 1))K"
        case 0...:
            return "\(self)"
        default:
            return "\(self)"
        }
    }
}

struct TextFieldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .frame(width: UIScreen.main.bounds.width * 0.95)
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

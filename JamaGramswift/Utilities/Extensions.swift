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

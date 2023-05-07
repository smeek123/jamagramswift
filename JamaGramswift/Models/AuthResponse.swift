//
//  AuthResponse.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/6/23.
//

import Foundation

//these fields will be used as part of apples built in json decoder to decode the response fron spotify
struct AuthResponse: Codable {
    let access_token: String
    let token_type: String
    let scope: String
    let expires_in: Int
    let refresh_token: String?
}

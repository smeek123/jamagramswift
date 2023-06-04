//
//  AuthResponse.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/6/23.
//

import Foundation

//the way ios apps gets data is called MVVM
//It means Model, view and view model
//this means we make a model of the data then the view model hols functions that get the data and decode it with the model then that decoded data is shown on the views aka the screens of the app. 
//these fields will be used as part of apples built in json decoder to decode the response fron spotify
struct AuthResponse: Codable {
    let access_token: String
    let token_type: String
    let scope: String
    let expires_in: Int
    let refresh_token: String?
}

//
//  AuthViewModel.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/6/23.
//

import Foundation
import SwiftUI
import CryptoKit
import Security

struct SpotifyAM {
    //appstorage variables store data in the devices database
    //the clientid and clien secret are generated on the spotify api dashboard and allow for authentication
    @State static var isRetrievingTokens: Bool = false
    @AppStorage("signedIn") static var isSignedIn: Bool = false
    @AppStorage("expiresAt") static var expiresAt: Date = Date()
    static let client_id: String = "243fed7dca8e464c912074d9f2e4e7b0"
    
    //the keychain is similar to appstorage but more secure and is often used for storing OAuth tokens or passwords
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
        case noPassword
    }
    
    //this is an asyncronous method that updates the access tokens when needed
    static func updateTokens(service: String, account: String, authData: Data) async throws {
        //this uses the apple security framework to access the keychain safely, this query provides the information about the token that should update
        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service as AnyObject, kSecAttrAccount as String: account as AnyObject]
        
        //this dictionary contains the fields that should be updated
        let attrubutes: [String: AnyObject] = [kSecValueData as String: authData as AnyObject]
        
        //this variable contains the return value so we can check for errors or success
        let status = SecItemUpdate(query as CFDictionary, attrubutes as CFDictionary)
        
        //these statements help check if certain errors are found for easier debugging
        guard status != errSecItemNotFound else {
            print("notFound")
            throw KeychainError.noPassword
        }
        
        guard status == errSecSuccess else {
            print("unkown update error")
            throw KeychainError.unknown(status)
        }
        
        //if none of the checks throw an error, the success variable is set to true
        await MainActor.run {
            SpotifyAM.isSignedIn = true
        }
        
        print(SpotifyAM.isSignedIn)
        print("updated")
    }
}

class SpotifyAuthManager: ObservableObject {
    let client_secret: String = "7d4f16ad367f408aa439112d2872ff40"
    //this url provides a place for spotify to send the user back to after the login process
    let redirect_uriURL: URL = URL(string: "jamagram-app://login-callback")!
    //these tell spotify what data the user wants to access
    let scopes: String = "user-modify-playback-state%20user-top-read%20user-read-private%20user-read-email%20playlist-modify-public%20playlist-modify-private"
    //these fields are included in the url that is passed to spotify for auth
    var inputState: String = ""
    var returnState: String = ""
    var returnCode: String = ""
    var returnError: String = ""
    var code_challenge: String = ""
    static var code_verifier: String = ""
    
    //this var makes sure the refresh token is requested with enough time to proccess before the token expires
    static var shouldRefresh: Bool {
        guard SpotifyAM.expiresAt <= Date().addingTimeInterval(300) else {
            return false
        }
        
        guard SpotifyAM.isRetrievingTokens == false else {
            return false
        }
        return true
    }
    
    //request an access and refresh token from spotify
    static func withCurrentToken() async -> String {
        var accessToken: String = ""
        do {
            if shouldRefresh {
                try await getRefreshedAccessToken()
            }
            
            guard let refreshData = try? getTokens(service: "spotify.com", account: "accessToken") else {
                throw URLError(.dataNotAllowed)
            }
            
            accessToken = String(decoding: refreshData, as: UTF8.self)
            return accessToken
        } catch {
            print(error.localizedDescription)
        }
        
        return accessToken
    }
    
    enum PKCEError: Error {
        case failedToGenerateRandomOctets
        case failedToCreateChallengeForVerifier
    }
    
    //creates a random string for the auth url parameter
    func randomString(length: Int) -> String {
        let chars: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_.-~"
        return String((0..<length).map{ _ in chars.randomElement()! })
    }
    
    //this is how spotify requires the request to be incrypted
    func generateCryptographicallySecureRandomOctets(count: Int) throws -> [UInt8] {
        var octets = [UInt8](repeating: 0, count: count)
        let status = SecRandomCopyBytes(kSecRandomDefault, octets.count, &octets)
        if status == errSecSuccess {
            return octets
        } else {
            throw PKCEError.failedToGenerateRandomOctets
        }
    }
    
    //this func encodes the string with the octates generated
    func base64URLEncode<S>(octets: S) -> String where S : Sequence, UInt8 == S.Element {
        let data = Data(octets)
        return data
            .base64EncodedString() // Regular base64 encoder
            .replacingOccurrences(of: "=", with: "") // Remove any trailing '='s
            .replacingOccurrences(of: "+", with: "-") // 62nd char of encoding
            .replacingOccurrences(of: "/", with: "_") // 63rd char of encoding
            .trimmingCharacters(in: .whitespaces)
    }
    
    //this function generates a code challenge that helps spotify safely create a token these are required because mobile apps do not have a safe way to store the client secret so in case of any issues these random strings will always be generated.
    func challenge(for verifier: String) throws -> String {
        let challenge = verifier
            .data(using: .ascii)
            .map { SHA256.hash(data: $0) }
            .map { base64URLEncode(octets: $0) }
        
        if let challenge = challenge {
            return challenge
        } else {
            throw PKCEError.failedToCreateChallengeForVerifier
        }
    }
    
    //this func takes all the parameters we generated and puts them into the url to be sent to the api
    func spotifyURL() -> URL {
        do {
            SpotifyAuthManager.code_verifier = try base64URLEncode(octets: generateCryptographicallySecureRandomOctets(count: 32))
            code_challenge = try challenge(for: SpotifyAuthManager.code_verifier)
        } catch {
            print(error.localizedDescription)
        }
        
        guard let spotifyURL: URL = URL(string: "https://accounts.spotify.com/authorize?response_type=code&client_id=\(SpotifyAM.client_id)&scope=\(scopes)&redirect_uri=\(redirect_uriURL.absoluteString)&state=\(inputState)&code_challenge_method=S256&code_challenge=\(String(describing: code_challenge))&show_dialog=TRUE") else {
            return URL(string: "https://google.com")!
        }
        
        print("first varifier \(SpotifyAuthManager.code_verifier)")
        return spotifyURL
    }
    
    //the url we generated will return a code and this func will hanle that code and access the date we want once our app is redirected to
    func HandleURLCode(_ url: URL) async {
        SpotifyAM.isRetrievingTokens = true
        
        //this checks to make sure the url is the correct url and not an attack
        guard url.scheme == self.redirect_uriURL.scheme else {
            print("Invalid scheme")
            return
        }
        
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        
        if let state = components?.queryItems?.first(where: { QueryItem -> Bool in
            QueryItem.name == "state"
        })?.value {
            returnState = state
        }
        
        //the url is broken into components and the component named code is stored
        if let code = components?.queryItems?.first(where: { QueryItem -> Bool in
            QueryItem.name == "code"
        })?.value {
            returnCode = code
            print("code \(returnCode)")
        }
        
        if let error = components?.queryItems?.first(where: { QueryItem -> Bool in
            QueryItem.name == "error"
        })?.value {
            returnError = error
            print("error getting code \(returnError)")
        }
        
        //the state is another safety measure which should be a string returned, the returned state should match the state that we passed in
        if returnState == inputState {
            if returnError == "" {
                try? await getAccessToken(accessCode: returnCode, verifier: SpotifyAuthManager.code_verifier)
                print("varifier \(SpotifyAuthManager.code_verifier)")
            } else {
                print("error getting token")
                print(returnError)
            }
        }
    }
    
    //this func takes the code we got and requests the tokens
    func getAccessToken(accessCode: String, verifier: String) async throws {
        //this key tells spotify that the jamagram app is requesting access
        let api_auth_key: String = "Basic \((SpotifyAM.client_id + ":" + client_secret).data(using: .utf8)!.base64EncodedString())"
        
        let requestHeaders: [String: String] = ["authorization" : api_auth_key, "Content-Type" : "application/x-www-form-urlencoded"]
        
        print("varifier in request \(SpotifyAuthManager.code_verifier)")
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "grant_type", value: "authorization_code"), URLQueryItem(name: "client_id", value: SpotifyAM.client_id), URLQueryItem(name: "code", value: accessCode), URLQueryItem(name: "redirect_uri", value: redirect_uriURL.absoluteString), URLQueryItem(name: "code_verifier", value: verifier)]
        
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        do {
            guard let data = requestBodyComponents.query?.data(using: .utf8) else {
                throw URLError(.dataNotAllowed)
            }
            
            //this is apples way to manage url requests and here we are uploading the code to spotify to get the token
            let (responseData, response) = try await
            URLSession.shared.upload(for: request, from: data)
            
            print(response)
            
//            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
//                fatalError("error with fetching data")
//            }
            
            //this tries to decode the response into a model that we can use to acces parts of the response
            let result = try JSONDecoder().decode(AuthResponse.self, from: responseData)
            
            //this func call the save token to the keychain
            try await saveToKeychain(service: "spotify.com", account: "accessToken", authData: result.access_token.data(using: .utf8) ?? Data())
            
            guard let refreshToken = result.refresh_token else {
                return
            }
            
            try await saveToKeychain(service: "spotify.com", account: "refreshToken", authData: refreshToken.data(using: .utf8) ?? Data())
            
            //this resets the expiration date of the tokens, the mainactor call is a way for swift to get back onto the main thread which is the only way to update these variables
            await MainActor.run {
                SpotifyAM.expiresAt = Date().addingTimeInterval(TimeInterval(result.expires_in))
                
                SpotifyAM.isSignedIn = true
            }
        } catch {
            print(error.localizedDescription)
        }
        
        await MainActor.run {
            SpotifyAM.isRetrievingTokens = false
        }
    }
    
    //saveauth data to keychain
    func saveToKeychain(service: String, account: String, authData: Data) async throws {
        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service as AnyObject, kSecAttrAccount as String: account as AnyObject, kSecValueData as String: authData as AnyObject]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecDuplicateItem {
            try? await SpotifyAM.updateTokens(service: service, account: account, authData: authData)
            print("duplicate")
            throw SpotifyAM.KeychainError.duplicateEntry
        } else {
            print("success")
        }
        
        if status != errSecSuccess {
            throw SpotifyAM.KeychainError.unknown(status)
        } else {
            print("success")
        }
        
        print("saved")
    }
    
    //request new access_token
    static func getRefreshedAccessToken() async throws {
        let requestHeaders: [String: String] = ["Content-Type": "application/x-www-form-urlencoded"]
        
        guard let refreshData = try? getTokens(service: "spotify.com", account: "refreshToken") else {
            throw URLError(.dataNotAllowed)
        }
        
        let refreshToken = String(decoding: refreshData, as: UTF8.self)
        
        var requestBodyComponents = URLComponents()
        requestBodyComponents.queryItems = [URLQueryItem(name: "grant_type", value: "refresh_token"), URLQueryItem(name: "client_id", value: SpotifyAM.client_id), URLQueryItem(name: "refresh_token", value: refreshToken)]
        
        var request = URLRequest(url: URL(string: "https://accounts.spotify.com/api/token")!)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = requestHeaders
        request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        
        do {
            guard let data = requestBodyComponents.query?.data(using: .utf8) else {
                throw URLError(.dataNotAllowed)
            }
            
            let (responseData, _) = try await
            URLSession.shared.upload(for: request, from: data)
            
            let result = try JSONDecoder().decode(AuthResponse.self, from: responseData)
            
            try await SpotifyAM.updateTokens(service: "spotify.com", account: "accessToken", authData: result.access_token.data(using: .utf8) ?? Data())
            
            guard let refreshToken = result.refresh_token else {
                return
            }
            
            try await SpotifyAM.updateTokens(service: "spotify.com", account: "refreshToken", authData: refreshToken.data(using: .utf8) ?? Data())
            
            print("refreshed")
            
            await MainActor.run(body: {
                SpotifyAM.expiresAt = Date().addingTimeInterval(TimeInterval(result.expires_in))
                
                SpotifyAM.isSignedIn = true
            })
        } catch {
            print("error getting data")
            print(error.localizedDescription)
        }
    }
    
    //read the refresh token and put it into call which should be after 3000 secconds from start of expired_in value
    static func getTokens(service: String, account: String) throws -> Data? {
        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service as AnyObject, kSecAttrAccount as String: account as AnyObject, kSecReturnData as String: kCFBooleanTrue, kSecMatchLimit as String: kSecMatchLimitOne]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        guard status != errSecItemNotFound else {
            print("notFound2")
            throw SpotifyAM.KeychainError.noPassword
        }
        
        guard status == errSecSuccess else {
            print("unkown match error")
            throw SpotifyAM.KeychainError.unknown(status)
        }
        
        return result as? Data
    }
    
    //deletes the old tokens
    static func deleteToken(service: String, accounr: String) async throws {
        let query: [String: AnyObject] = [kSecClass as String: kSecClassGenericPassword, kSecAttrService as String: service as AnyObject, kSecAttrAccount as String: accounr as AnyObject]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status != errSecItemNotFound else {
            print("notFound")
            throw SpotifyAM.KeychainError.noPassword
        }
        
        guard status == errSecSuccess else {
            print("unkown delete error")
            throw SpotifyAM.KeychainError.unknown(status)
        }
        
        await MainActor.run {
            SpotifyAM.isSignedIn = false
        }
    }
}

//
//  JamaGramswiftApp.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/5/23.
//

import SwiftUI
import AVKit

@main
struct JamaGramswiftApp: App {
    func setAudioSession()  {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
        } catch {
            print("error with audio session")
        }
    }
    
    init() {
        setAudioSession()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

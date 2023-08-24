//
//  JamaGramswiftApp.swift
//  JamaGramswift
//
//  Created by Sean P. Meek on 5/5/23.
//

import SwiftUI
import AVKit
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

//main app that initializeses the app
@main
struct JamaGramswiftApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    //sets up the audio capabilities for the preview links
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
    
    //this is the first screen shown when the app loads
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

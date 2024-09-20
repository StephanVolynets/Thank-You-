//
//  Thank_You_App.swift
//  Thank You!
//
//  Created by Tyler Forstrom on 9/17/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct Thank_You_App: App {
    init() {
        FirebaseApp.configure() // Initialize Firebase
    }

    var body: some Scene {
        WindowGroup {
            MainPage()
        }
    }
}

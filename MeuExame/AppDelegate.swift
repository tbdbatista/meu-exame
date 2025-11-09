//
//  AppDelegate.swift
//  MeuExame
//
//  Created on 11/9/2025.
//  Copyright © 2025 MeuExame. All rights reserved.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties
    
    /// Firebase configuration manager - can be injected for testing
    var firebaseManager: FirebaseConfigurable = FirebaseManager.shared
    
    // MARK: - UIApplicationDelegate
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Configure Firebase
        configureFirebase()
        
        // Additional app configuration can be added here
        
        return true
    }
    
    // MARK: - Private Methods
    
    /// Configures Firebase using dependency injection
    private func configureFirebase() {
        firebaseManager.configure()
        
        if firebaseManager.isConfigured() {
            print("✅ Firebase initialized successfully in AppDelegate")
        } else {
            print("⚠️ Firebase configuration incomplete. Add GoogleService-Info.plist to proceed.")
        }
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

}


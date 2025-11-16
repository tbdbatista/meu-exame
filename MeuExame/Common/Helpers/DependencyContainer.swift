//
//  DependencyContainer.swift
//  MeuExame
//
//  Created on 11/9/2025.
//  Copyright © 2025 MeuExame. All rights reserved.
//

import Foundation
import UIKit

/// Dependency Injection Container for the app
/// Provides centralized management of dependencies following VIPER architecture
final class DependencyContainer {
    
    // MARK: - Singleton
    
    static let shared = DependencyContainer()
    
    // MARK: - Properties
    
    /// Firebase configuration manager
    let firebaseManager: FirebaseConfigurable
    
    // MARK: - Initialization
    
    private init() {
        // Initialize Firebase manager
        self.firebaseManager = FirebaseManager.shared
    }
    
    /// Custom initializer for testing with mock dependencies
    /// - Parameter firebaseManager: Custom Firebase manager implementation
    init(firebaseManager: FirebaseConfigurable) {
        self.firebaseManager = firebaseManager
    }
    
    // MARK: - Services
    
    /// Creates an ExamesService instance
    /// - Returns: Configured ExamesServiceProtocol implementation
    func makeExamesService() -> ExamesServiceProtocol {
        return FirestoreExamesService()
    }
    
    /// Creates a UserService instance
    /// - Returns: Configured UserServiceProtocol implementation
    func makeUserService() -> UserServiceProtocol {
        return FirestoreUserService()
    }
    
    /// Creates a NotificationService instance
    /// - Returns: Configured NotificationServiceProtocol implementation
    func makeNotificationService() -> NotificationServiceProtocol {
        return LocalNotificationService()
    }
}

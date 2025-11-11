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
    
    // MARK: - Factory Methods
    
    /// Creates a Login VIPER module with all dependencies
    /// - Returns: Configured Login view controller
    func makeLoginModule() -> UIViewController {
        // TODO: Implement when Login module is created
        // let view = LoginViewController()
        // let presenter = LoginPresenter()
        // let interactor = LoginInteractor(firebaseAuth: firebaseManager as? FirebaseAuthenticationService)
        // let router = LoginRouter()
        // 
        // view.presenter = presenter
        // presenter.view = view
        // presenter.interactor = interactor
        // presenter.router = router
        // interactor.output = presenter
        // router.viewController = view
        //
        // return view
        
        return UIViewController()
    }
    
    /// Creates an ExamesList VIPER module with all dependencies
    /// - Returns: Configured ExamesList view controller
    func makeExamesListModule() -> UIViewController {
        let exameService = makeExamesService()
        
        let view = ExamesListViewController()
        let presenter = ExamesListPresenter()
        let interactor = ExamesListInteractor(exameService: exameService)
        let router = ExamesListRouter()
        
        view.presenter = presenter
        
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        interactor.presenter = presenter
        interactor.output = presenter
        
        router.viewController = view
        
        return view
    }
}


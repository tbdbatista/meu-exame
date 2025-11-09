//
//  FirebaseConfigurable.swift
//  MeuExame
//
//  Created on 11/9/2025.
//  Copyright © 2025 MeuExame. All rights reserved.
//

import Foundation

/// Protocol that defines Firebase configuration capabilities
/// Used for dependency injection to allow for testability and flexibility
protocol FirebaseConfigurable {
    /// Configures and initializes Firebase services
    func configure()
    
    /// Checks if Firebase has been properly configured
    /// - Returns: Boolean indicating configuration status
    func isConfigured() -> Bool
}

/// Protocol for Firebase Authentication operations
protocol FirebaseAuthenticationService {
    /// Signs in user with email and password
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    
    /// Signs up new user with email and password
    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    
    /// Signs out current user
    func signOut() throws
    
    /// Gets current user ID
    func getCurrentUserId() -> String?
}

/// Protocol for Firebase Firestore operations
protocol FirebaseFirestoreService {
    /// Saves data to Firestore
    func save<T: Encodable>(data: T, to collection: String, documentId: String?, completion: @escaping (Result<String, Error>) -> Void)
    
    /// Fetches data from Firestore
    func fetch<T: Decodable>(from collection: String, documentId: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void)
    
    /// Deletes document from Firestore
    func delete(from collection: String, documentId: String, completion: @escaping (Result<Void, Error>) -> Void)
}

/// Protocol for Firebase Storage operations
protocol FirebaseStorageService {
    /// Uploads file to Firebase Storage
    func upload(data: Data, to path: String, completion: @escaping (Result<String, Error>) -> Void)
    
    /// Downloads file from Firebase Storage
    func download(from path: String, completion: @escaping (Result<Data, Error>) -> Void)
    
    /// Deletes file from Firebase Storage
    func delete(from path: String, completion: @escaping (Result<Void, Error>) -> Void)
}


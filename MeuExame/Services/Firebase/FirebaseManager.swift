//
//  FirebaseManager.swift
//  MeuExame
//
//  Created on 11/9/2025.
//  Copyright © 2025 MeuExame. All rights reserved.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

/// Singleton manager for Firebase services
/// Implements dependency injection pattern for testability
final class FirebaseManager: FirebaseConfigurable {
    
    // MARK: - Singleton
    
    static let shared = FirebaseManager()
    
    // MARK: - Properties
    
    private var configured = false
    
    // Firebase service instances
    private(set) var auth: Auth?
    private(set) var firestore: Firestore?
    private(set) var storage: Storage?
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - FirebaseConfigurable
    
    /// Configures Firebase with GoogleService-Info.plist
    /// - Note: Ensure GoogleService-Info.plist is added to the project before calling this method
    func configure() {
        guard !configured else {
            print("⚠️ Firebase already configured")
            return
        }
        
        // Check if GoogleService-Info.plist exists
        guard let plistPath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist"),
              FileManager.default.fileExists(atPath: plistPath) else {
            print("❌ GoogleService-Info.plist not found. Please add it to your project.")
            print("📝 You can download it from Firebase Console: https://console.firebase.google.com")
            return
        }
        
        // Configure Firebase
        FirebaseApp.configure()
        
        // Initialize services
        self.auth = Auth.auth()
        self.firestore = Firestore.firestore()
        self.storage = Storage.storage()
        
        // Configure Firestore settings for better performance
        let settings = FirestoreSettings()
        settings.isPersistenceEnabled = true
        settings.cacheSizeBytes = FirestoreCacheSizeUnlimited
        self.firestore?.settings = settings
        
        configured = true
        print("✅ Firebase configured successfully")
    }
    
    func isConfigured() -> Bool {
        return configured
    }
    
    // MARK: - Helper Methods
    
    /// Resets Firebase configuration (useful for testing)
    func reset() {
        configured = false
        auth = nil
        firestore = nil
        storage = nil
    }
}

// MARK: - FirebaseAuthenticationService

extension FirebaseManager: FirebaseAuthenticationService {
    
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let auth = auth else {
            completion(.failure(FirebaseError.notConfigured))
            return
        }
        
        auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = authResult?.user.uid else {
                completion(.failure(FirebaseError.unknownError))
                return
            }
            
            completion(.success(userId))
        }
    }
    
    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let auth = auth else {
            completion(.failure(FirebaseError.notConfigured))
            return
        }
        
        auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let userId = authResult?.user.uid else {
                completion(.failure(FirebaseError.unknownError))
                return
            }
            
            completion(.success(userId))
        }
    }
    
    func signOut() throws {
        guard let auth = auth else {
            throw FirebaseError.notConfigured
        }
        
        try auth.signOut()
    }
    
    func getCurrentUserId() -> String? {
        return auth?.currentUser?.uid
    }
}

// MARK: - FirebaseFirestoreService

extension FirebaseManager: FirebaseFirestoreService {
    
    func save<T: Encodable>(data: T, to collection: String, documentId: String?, completion: @escaping (Result<String, Error>) -> Void) {
        guard let firestore = firestore else {
            completion(.failure(FirebaseError.notConfigured))
            return
        }
        
        do {
            let encoder = JSONEncoder()
            let jsonData = try encoder.encode(data)
            let dictionary = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] ?? [:]
            
            let docRef: DocumentReference
            if let documentId = documentId {
                docRef = firestore.collection(collection).document(documentId)
            } else {
                docRef = firestore.collection(collection).document()
            }
            
            docRef.setData(dictionary) { error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                completion(.success(docRef.documentID))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func fetch<T: Decodable>(from collection: String, documentId: String, as type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        guard let firestore = firestore else {
            completion(.failure(FirebaseError.notConfigured))
            return
        }
        
        firestore.collection(collection).document(documentId).getDocument { document, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let document = document, document.exists,
                  let data = document.data() else {
                completion(.failure(FirebaseError.documentNotFound))
                return
            }
            
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: jsonData)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    func delete(from collection: String, documentId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let firestore = firestore else {
            completion(.failure(FirebaseError.notConfigured))
            return
        }
        
        firestore.collection(collection).document(documentId).delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
}

// MARK: - FirebaseStorageService

extension FirebaseManager: FirebaseStorageService {
    
    func upload(data: Data, to path: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let storage = storage else {
            completion(.failure(FirebaseError.notConfigured))
            return
        }
        
        let storageRef = storage.reference().child(path)
        
        storageRef.putData(data, metadata: nil) { metadata, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { url, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url?.absoluteString else {
                    completion(.failure(FirebaseError.unknownError))
                    return
                }
                
                completion(.success(downloadURL))
            }
        }
    }
    
    func download(from path: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let storage = storage else {
            completion(.failure(FirebaseError.notConfigured))
            return
        }
        
        let storageRef = storage.reference().child(path)
        
        // Download in memory with a maximum allowed size of 10MB (10 * 1024 * 1024 bytes)
        storageRef.getData(maxSize: 10 * 1024 * 1024) { data, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(FirebaseError.unknownError))
                return
            }
            
            completion(.success(data))
        }
    }
    
    func delete(from path: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let storage = storage else {
            completion(.failure(FirebaseError.notConfigured))
            return
        }
        
        let storageRef = storage.reference().child(path)
        
        storageRef.delete { error in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
}

// MARK: - Firebase Errors

enum FirebaseError: LocalizedError {
    case notConfigured
    case documentNotFound
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .notConfigured:
            return "Firebase is not configured. Please call configure() first."
        case .documentNotFound:
            return "Document not found in Firestore."
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}


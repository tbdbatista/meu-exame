import Foundation
import FirebaseFirestore
import FirebaseAuth

/// Service implementation for managing Exam records in Firestore.
/// Provides CRUD operations with Firebase Firestore backend.
final class FirestoreExamesService: ExamesServiceProtocol {
    
    // MARK: - Properties
    
    private let db = Firestore.firestore()
    
    // MARK: - Private Helpers
    
    /// Gets the current user's ID
    /// - Returns: User ID if authenticated, nil otherwise
    private func getCurrentUserId() -> String? {
        return Auth.auth().currentUser?.uid
    }
    
    /// Gets the collection reference for current user's exams
    /// - Returns: CollectionReference if user is authenticated, nil otherwise
    private func getExamesCollection() -> CollectionReference? {
        guard let userId = getCurrentUserId() else {
            print("❌ FirestoreExamesService: User not authenticated")
            return nil
        }
        return FirestoreAdapter.examesCollection(for: userId)
    }
    
    // MARK: - ExamesServiceProtocol Implementation
    
    func create(exame: ExameModel, completion: @escaping (Result<ExameModel, ExameServiceError>) -> Void) {
        guard let collection = getExamesCollection() else {
            completion(.failure(.unauthorized))
            return
        }
        
        print("📝 FirestoreExamesService: Creating exam '\(exame.nome)'")
        
        let data = FirestoreAdapter.toFirestore(exame)
        
        // Use the exam's ID as the document ID
        let documentRef = collection.document(exame.id)
        
        documentRef.setData(data) { error in
            if let error = error {
                print("❌ FirestoreExamesService: Create failed - \(error.localizedDescription)")
                completion(.failure(.unknown(error)))
                return
            }
            
            print("✅ FirestoreExamesService: Exam created successfully")
            completion(.success(exame))
        }
    }
    
    func fetch(completion: @escaping (Result<[ExameModel], ExameServiceError>) -> Void) {
        guard let collection = getExamesCollection() else {
            completion(.failure(.unauthorized))
            return
        }
        
        print("📥 FirestoreExamesService: Fetching all exams")
        
        collection
            .order(by: "dataCadastro", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ FirestoreExamesService: Fetch failed - \(error.localizedDescription)")
                    completion(.failure(.unknown(error)))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("⚠️ FirestoreExamesService: No documents found")
                    completion(.success([]))
                    return
                }
                
                let exames = FirestoreAdapter.fromFirestore(documents)
                print("✅ FirestoreExamesService: Fetched \(exames.count) exams")
                completion(.success(exames))
            }
    }
    
    func fetchById(id: String, completion: @escaping (Result<ExameModel, ExameServiceError>) -> Void) {
        guard let collection = getExamesCollection() else {
            completion(.failure(.unauthorized))
            return
        }
        
        print("📥 FirestoreExamesService: Fetching exam with ID '\(id)'")
        
        collection.document(id).getDocument { snapshot, error in
            if let error = error {
                print("❌ FirestoreExamesService: Fetch by ID failed - \(error.localizedDescription)")
                completion(.failure(.unknown(error)))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                print("⚠️ FirestoreExamesService: Exam not found")
                completion(.failure(.notFound))
                return
            }
            
            guard let exame = FirestoreAdapter.fromFirestore(snapshot) else {
                print("❌ FirestoreExamesService: Failed to parse exam")
                completion(.failure(.parsingError))
                return
            }
            
            print("✅ FirestoreExamesService: Exam fetched successfully")
            completion(.success(exame))
        }
    }
    
    func update(exame: ExameModel, completion: @escaping (Result<Void, ExameServiceError>) -> Void) {
        guard let collection = getExamesCollection() else {
            completion(.failure(.unauthorized))
            return
        }
        
        print("✏️ FirestoreExamesService: Updating exam '\(exame.nome)'")
        
        let data = FirestoreAdapter.toFirestoreUpdate(exame)
        
        collection.document(exame.id).updateData(data) { error in
            if let error = error {
                print("❌ FirestoreExamesService: Update failed - \(error.localizedDescription)")
                
                // Check if document doesn't exist
                if (error as NSError).code == FirestoreErrorCode.notFound.rawValue {
                    completion(.failure(.notFound))
                } else {
                    completion(.failure(.unknown(error)))
                }
                return
            }
            
            print("✅ FirestoreExamesService: Exam updated successfully")
            completion(.success(()))
        }
    }
    
    func delete(id: String, completion: @escaping (Result<Void, ExameServiceError>) -> Void) {
        guard let collection = getExamesCollection() else {
            completion(.failure(.unauthorized))
            return
        }
        
        print("🗑️ FirestoreExamesService: Deleting exam with ID '\(id)'")
        
        collection.document(id).delete { error in
            if let error = error {
                print("❌ FirestoreExamesService: Delete failed - \(error.localizedDescription)")
                completion(.failure(.unknown(error)))
                return
            }
            
            print("✅ FirestoreExamesService: Exam deleted successfully")
            completion(.success(()))
        }
    }
    
    func search(query: String, completion: @escaping (Result<[ExameModel], ExameServiceError>) -> Void) {
        // For now, fetch all and filter locally
        // In production, consider using Algolia or ElasticSearch for better search
        
        print("🔍 FirestoreExamesService: Searching for '\(query)'")
        
        fetch { result in
            switch result {
            case .success(let exames):
                let filtered = exames.filter { exame in
                    exame.nome.localizedCaseInsensitiveContains(query) ||
                    exame.localRealizado.localizedCaseInsensitiveContains(query) ||
                    exame.medicoSolicitante.localizedCaseInsensitiveContains(query) ||
                    exame.motivoQueixa.localizedCaseInsensitiveContains(query)
                }
                print("✅ FirestoreExamesService: Found \(filtered.count) results")
                completion(.success(filtered))
                
            case .failure(let error):
                print("❌ FirestoreExamesService: Search failed")
                completion(.failure(error))
            }
        }
    }
}

// MARK: - Real-time Updates (Optional Extension)

extension FirestoreExamesService {
    /// Adds a real-time listener for exams
    /// - Parameter onChange: Callback when data changes
    /// - Returns: ListenerRegistration to remove listener later
    func addListener(onChange: @escaping (Result<[ExameModel], ExameServiceError>) -> Void) -> ListenerRegistration? {
        guard let collection = getExamesCollection() else {
            onChange(.failure(.unauthorized))
            return nil
        }
        
        print("👂 FirestoreExamesService: Adding real-time listener")
        
        return collection
            .order(by: "dataCadastro", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("❌ FirestoreExamesService: Listener error - \(error.localizedDescription)")
                    onChange(.failure(.unknown(error)))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    onChange(.success([]))
                    return
                }
                
                let exames = FirestoreAdapter.fromFirestore(documents)
                print("🔄 FirestoreExamesService: Data changed, \(exames.count) exams")
                onChange(.success(exames))
            }
    }
}

// MARK: - Batch Operations (Optional Extension)

extension FirestoreExamesService {
    /// Deletes multiple exams in a batch
    /// - Parameters:
    ///   - ids: Array of exam IDs to delete
    ///   - completion: Completion handler
    func batchDelete(ids: [String], completion: @escaping (Result<Void, ExameServiceError>) -> Void) {
        guard let userId = getCurrentUserId() else {
            completion(.failure(.unauthorized))
            return
        }
        
        print("🗑️ FirestoreExamesService: Batch deleting \(ids.count) exams")
        
        let batch = db.batch()
        let collection = FirestoreAdapter.examesCollection(for: userId)
        
        ids.forEach { id in
            let docRef = collection.document(id)
            batch.deleteDocument(docRef)
        }
        
        batch.commit { error in
            if let error = error {
                print("❌ FirestoreExamesService: Batch delete failed - \(error.localizedDescription)")
                completion(.failure(.unknown(error)))
                return
            }
            
            print("✅ FirestoreExamesService: Batch delete successful")
            completion(.success(()))
        }
    }
}


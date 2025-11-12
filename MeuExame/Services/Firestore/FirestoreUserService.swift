import Foundation
import FirebaseAuth
import FirebaseFirestore

// MARK: - FirestoreUserService

/// Implementation of UserServiceProtocol using Firebase Firestore
final class FirestoreUserService: UserServiceProtocol {
    
    // MARK: - Properties
    
    private let db = Firestore.firestore()
    private let collectionName = "users"
    
    // MARK: - UserServiceProtocol Implementation
    
    func fetchCurrentUser(completion: @escaping (Result<UserModel, UserServiceError>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(.userNotFound))
            return
        }
        
        let docRef = db.collection(collectionName).document(currentUser.uid)
        
        docRef.getDocument { snapshot, error in
            if let error = error {
                print("❌ FirestoreUserService: Error fetching user - \(error.localizedDescription)")
                completion(.failure(.firestoreError(error)))
                return
            }
            
            guard let snapshot = snapshot, snapshot.exists else {
                // User document doesn't exist yet, create from Auth data
                let newUser = UserModel(
                    uid: currentUser.uid,
                    nome: currentUser.displayName,
                    email: currentUser.email ?? "",
                    photoURL: currentUser.photoURL?.absoluteString
                )
                completion(.success(newUser))
                return
            }
            
            do {
                var user = try snapshot.data(as: UserModel.self)
                // Ensure email is up to date from Auth
                if user.email.isEmpty, let email = currentUser.email {
                    user = UserModel(
                        uid: user.uid,
                        nome: user.nome,
                        email: email,
                        telefone: user.telefone,
                        dataNascimento: user.dataNascimento,
                        photoURL: user.photoURL,
                        dataCriacao: user.dataCriacao,
                        dataAtualizacao: user.dataAtualizacao
                    )
                }
                print("✅ FirestoreUserService: User fetched successfully")
                completion(.success(user))
            } catch {
                print("❌ FirestoreUserService: Error decoding user - \(error.localizedDescription)")
                completion(.failure(.invalidData))
            }
        }
    }
    
    func saveUser(_ user: UserModel, completion: @escaping (Result<Void, UserServiceError>) -> Void) {
        let docRef = db.collection(collectionName).document(user.uid)
        
        do {
            try docRef.setData(from: user, merge: true) { error in
                if let error = error {
                    print("❌ FirestoreUserService: Error saving user - \(error.localizedDescription)")
                    completion(.failure(.firestoreError(error)))
                    return
                }
                print("✅ FirestoreUserService: User saved successfully")
                completion(.success(()))
            }
        } catch {
            print("❌ FirestoreUserService: Error encoding user - \(error.localizedDescription)")
            completion(.failure(.invalidData))
        }
    }
    
    func updateUser(uid: String, fields: [String: Any], completion: @escaping (Result<Void, UserServiceError>) -> Void) {
        var updatedFields = fields
        updatedFields["data_atualizacao"] = Timestamp(date: Date())
        
        let docRef = db.collection(collectionName).document(uid)
        
        docRef.updateData(updatedFields) { error in
            if let error = error {
                print("❌ FirestoreUserService: Error updating user - \(error.localizedDescription)")
                completion(.failure(.updateFailed))
                return
            }
            print("✅ FirestoreUserService: User updated successfully")
            completion(.success(()))
        }
    }
    
    func deleteUser(uid: String, completion: @escaping (Result<Void, UserServiceError>) -> Void) {
        let docRef = db.collection(collectionName).document(uid)
        
        docRef.delete { error in
            if let error = error {
                print("❌ FirestoreUserService: Error deleting user - \(error.localizedDescription)")
                completion(.failure(.deleteFailed))
                return
            }
            print("✅ FirestoreUserService: User deleted from Firestore")
            completion(.success(()))
        }
    }
    
    func changePassword(newPassword: String, completion: @escaping (Result<Void, UserServiceError>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(.userNotFound))
            return
        }
        
        currentUser.updatePassword(to: newPassword) { error in
            if let error = error {
                print("❌ FirestoreUserService: Error changing password - \(error.localizedDescription)")
                completion(.failure(.authError(error)))
                return
            }
            print("✅ FirestoreUserService: Password changed successfully")
            completion(.success(()))
        }
    }
    
    func deleteAccount(completion: @escaping (Result<Void, UserServiceError>) -> Void) {
        guard let currentUser = Auth.auth().currentUser else {
            completion(.failure(.userNotFound))
            return
        }
        
        let uid = currentUser.uid
        
        // First delete Firestore document
        deleteUser(uid: uid) { [weak self] result in
            switch result {
            case .success:
                // Then delete Auth account
                currentUser.delete { error in
                    if let error = error {
                        print("❌ FirestoreUserService: Error deleting Auth account - \(error.localizedDescription)")
                        completion(.failure(.authError(error)))
                        return
                    }
                    print("✅ FirestoreUserService: Account deleted successfully")
                    completion(.success(()))
                }
                
            case .failure(let error):
                print("⚠️ FirestoreUserService: Failed to delete Firestore user, but continuing with Auth deletion")
                // Continue with Auth deletion even if Firestore fails
                currentUser.delete { authError in
                    if let authError = authError {
                        print("❌ FirestoreUserService: Error deleting Auth account - \(authError.localizedDescription)")
                        completion(.failure(.authError(authError)))
                        return
                    }
                    print("✅ FirestoreUserService: Auth account deleted (Firestore deletion failed)")
                    completion(.success(()))
                }
            }
        }
    }
}


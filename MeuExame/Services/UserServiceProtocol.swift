import Foundation

// MARK: - UserServiceError

/// Errors that can occur during user service operations
enum UserServiceError: Error {
    case userNotFound
    case invalidData
    case updateFailed
    case deleteFailed
    case firestoreError(Error)
    case authError(Error)
    
    var localizedDescription: String {
        switch self {
        case .userNotFound:
            return "Usuário não encontrado"
        case .invalidData:
            return "Dados inválidos"
        case .updateFailed:
            return "Falha ao atualizar perfil"
        case .deleteFailed:
            return "Falha ao excluir conta"
        case .firestoreError(let error):
            return "Erro no Firestore: \(error.localizedDescription)"
        case .authError(let error):
            return "Erro de autenticação: \(error.localizedDescription)"
        }
    }
}

// MARK: - UserServiceProtocol

/// Protocol for user-related operations
protocol UserServiceProtocol {
    /// Fetches the current user's profile
    /// - Parameter completion: Completion handler with Result containing UserModel or Error
    func fetchCurrentUser(completion: @escaping (Result<UserModel, UserServiceError>) -> Void)
    
    /// Creates or updates a user profile
    /// - Parameters:
    ///   - user: UserModel to save
    ///   - completion: Completion handler with Result containing Void or Error
    func saveUser(_ user: UserModel, completion: @escaping (Result<Void, UserServiceError>) -> Void)
    
    /// Updates user profile fields
    /// - Parameters:
    ///   - uid: User ID
    ///   - fields: Dictionary of fields to update
    ///   - completion: Completion handler with Result containing Void or Error
    func updateUser(uid: String, fields: [String: Any], completion: @escaping (Result<Void, UserServiceError>) -> Void)
    
    /// Deletes user profile from Firestore
    /// - Parameters:
    ///   - uid: User ID
    ///   - completion: Completion handler with Result containing Void or Error
    func deleteUser(uid: String, completion: @escaping (Result<Void, UserServiceError>) -> Void)
    
    /// Changes user password
    /// - Parameters:
    ///   - newPassword: New password
    ///   - completion: Completion handler with Result containing Void or Error
    func changePassword(newPassword: String, completion: @escaping (Result<Void, UserServiceError>) -> Void)
    
    /// Deletes user account (Auth + Firestore)
    /// - Parameter completion: Completion handler with Result containing Void or Error
    func deleteAccount(completion: @escaping (Result<Void, UserServiceError>) -> Void)
}


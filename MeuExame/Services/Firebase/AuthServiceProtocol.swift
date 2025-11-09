import Foundation
import FirebaseAuth

// MARK: - AuthServiceProtocol

/// Protocol defining authentication service operations.
/// This protocol abstracts the authentication implementation, allowing for:
/// - Dependency Injection
/// - Unit Testing (mock implementations)
/// - Flexibility to change auth providers
protocol AuthServiceProtocol {
    /// Signs in a user with email and password
    /// - Parameters:
    ///   - email: User's email address
    ///   - password: User's password
    ///   - completion: Completion handler with Result containing user ID or error
    func signIn(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    
    /// Signs up a new user with email and password
    /// - Parameters:
    ///   - email: New user's email address
    ///   - password: New user's password
    ///   - completion: Completion handler with Result containing user ID or error
    func signUp(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void)
    
    /// Signs out the current user
    /// - Throws: Error if sign out fails
    func signOut() throws
    
    /// Returns the current authenticated user's ID
    var currentUserId: String? { get }
    
    /// Returns true if a user is currently signed in
    var isSignedIn: Bool { get }
    
    /// Sends a password reset email to the specified address
    /// - Parameters:
    ///   - email: Email address to send reset link
    ///   - completion: Completion handler with Result indicating success or error
    func sendPasswordReset(email: String, completion: @escaping (Result<Void, Error>) -> Void)
}

// MARK: - FirebaseManager + AuthServiceProtocol

extension FirebaseManager: AuthServiceProtocol {
    var currentUserId: String? {
        return auth?.currentUser?.uid
    }
    
    var isSignedIn: Bool {
        return auth?.currentUser != nil
    }
    
    func sendPasswordReset(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let auth = auth else {
            completion(.failure(FirebaseError.notConfigured))
            return
        }
        
        auth.sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Note: signIn and signUp are already implemented in FirebaseAuthenticationService extension
}

// MARK: - AuthError

/// Custom authentication errors
enum AuthError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case userNotFound
    case emailAlreadyInUse
    case weakPassword
    case networkError
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "E-mail inválido. Por favor, verifique e tente novamente."
        case .invalidPassword:
            return "Senha incorreta. Por favor, tente novamente."
        case .userNotFound:
            return "Usuário não encontrado. Verifique o e-mail ou crie uma conta."
        case .emailAlreadyInUse:
            return "Este e-mail já está em uso. Tente fazer login ou use outro e-mail."
        case .weakPassword:
            return "Senha muito fraca. Use pelo menos 6 caracteres."
        case .networkError:
            return "Erro de conexão. Verifique sua internet e tente novamente."
        case .unknown:
            return "Ocorreu um erro desconhecido. Por favor, tente novamente."
        }
    }
}

// MARK: - Firebase Error Mapper

extension Error {
    /// Converts Firebase error codes to AuthError
    var asAuthError: AuthError {
        let nsError = self as NSError
        
        guard let errorCode = AuthErrorCode(rawValue: nsError.code) else {
            return .unknown
        }
        
        switch errorCode {
        case .invalidEmail:
            return .invalidEmail
        case .wrongPassword:
            return .invalidPassword
        case .userNotFound:
            return .userNotFound
        case .emailAlreadyInUse:
            return .emailAlreadyInUse
        case .weakPassword:
            return .weakPassword
        case .networkError:
            return .networkError
        default:
            return .unknown
        }
    }
}


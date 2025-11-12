import Foundation

// MARK: - UserModel

/// Represents a user in the system.
/// This model stores user profile information in Firestore.
struct UserModel: Codable, Identifiable, Equatable {
    
    // MARK: - Properties
    
    /// Unique identifier (Firebase Auth UID)
    let uid: String
    
    /// User's full name
    var nome: String?
    
    /// User's email (from Firebase Auth)
    let email: String
    
    /// User's phone number
    var telefone: String?
    
    /// User's date of birth
    var dataNascimento: Date?
    
    /// URL to profile photo in Firebase Storage
    var photoURL: String?
    
    /// Account creation date
    let dataCriacao: Date
    
    /// Last profile update date
    var dataAtualizacao: Date
    
    // MARK: - Computed Properties
    
    var id: String {
        return uid
    }
    
    /// Returns formatted date of birth
    var dataNascimentoFormatada: String? {
        guard let data = dataNascimento else { return nil }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: data)
    }
    
    /// Returns user initials for avatar placeholder
    var initials: String {
        if let nome = nome, !nome.isEmpty {
            let components = nome.split(separator: " ")
            if components.count >= 2 {
                let first = String(components[0].prefix(1))
                let last = String(components[components.count - 1].prefix(1))
                return "\(first)\(last)".uppercased()
            } else {
                return String(nome.prefix(2)).uppercased()
            }
        }
        return String(email.prefix(2)).uppercased()
    }
    
    /// Returns display name (nome or email)
    var displayName: String {
        return nome ?? email
    }
    
    // MARK: - Initializer
    
    /// Creates a new UserModel instance
    /// - Parameters:
    ///   - uid: Firebase Auth UID
    ///   - nome: User's full name
    ///   - email: User's email
    ///   - telefone: User's phone number
    ///   - dataNascimento: User's date of birth
    ///   - photoURL: URL to profile photo
    ///   - dataCriacao: Account creation date
    ///   - dataAtualizacao: Last update date
    init(
        uid: String,
        nome: String? = nil,
        email: String,
        telefone: String? = nil,
        dataNascimento: Date? = nil,
        photoURL: String? = nil,
        dataCriacao: Date = Date(),
        dataAtualizacao: Date = Date()
    ) {
        self.uid = uid
        self.nome = nome
        self.email = email
        self.telefone = telefone
        self.dataNascimento = dataNascimento
        self.photoURL = photoURL
        self.dataCriacao = dataCriacao
        self.dataAtualizacao = dataAtualizacao
    }
    
    // MARK: - Coding Keys
    
    /// Custom coding keys for Firebase Firestore compatibility
    enum CodingKeys: String, CodingKey {
        case uid
        case nome
        case email
        case telefone
        case dataNascimento = "data_nascimento"
        case photoURL = "photo_url"
        case dataCriacao = "data_criacao"
        case dataAtualizacao = "data_atualizacao"
    }
}

// MARK: - UserModel + Mock Data

extension UserModel {
    /// Creates mock data for testing and preview purposes
    static func mock() -> UserModel {
        return UserModel(
            uid: "mock-user-123",
            nome: "João Silva",
            email: "joao.silva@example.com",
            telefone: "(11) 98765-4321",
            dataNascimento: Calendar.current.date(byAdding: .year, value: -30, to: Date()),
            photoURL: nil,
            dataCriacao: Date(),
            dataAtualizacao: Date()
        )
    }
}

// MARK: - UserModel + Validation

extension UserModel {
    /// Validates if the user model has required fields
    /// - Returns: True if valid, false otherwise
    func isValid() -> Bool {
        return !uid.isEmpty && !email.isEmpty
    }
    
    /// Returns validation errors as an array of strings
    /// - Returns: Array of error messages (empty if valid)
    func validationErrors() -> [String] {
        var errors: [String] = []
        
        if uid.isEmpty {
            errors.append("UID é obrigatório")
        }
        
        if email.isEmpty {
            errors.append("Email é obrigatório")
        }
        
        if let telefone = telefone, !telefone.isEmpty {
            // Basic phone validation
            let digits = telefone.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            if digits.count < 10 || digits.count > 11 {
                errors.append("Telefone inválido")
            }
        }
        
        return errors
    }
}


import Foundation

/// Protocol defining the contract for Exam data service operations.
/// Follows CRUD pattern for managing exam records.
protocol ExamesServiceProtocol {
    /// Creates a new exam in the data store
    /// - Parameters:
    ///   - exame: The exam model to create
    ///   - completion: Completion handler with Result containing the created exam or error
    func create(exame: ExameModel, completion: @escaping (Result<ExameModel, ExameServiceError>) -> Void)
    
    /// Fetches all exams from the data store
    /// - Parameter completion: Completion handler with Result containing array of exams or error
    func fetch(completion: @escaping (Result<[ExameModel], ExameServiceError>) -> Void)
    
    /// Fetches a specific exam by ID
    /// - Parameters:
    ///   - id: The unique identifier of the exam
    ///   - completion: Completion handler with Result containing the exam or error
    func fetchById(id: String, completion: @escaping (Result<ExameModel, ExameServiceError>) -> Void)
    
    /// Updates an existing exam in the data store
    /// - Parameters:
    ///   - exame: The exam model with updated data
    ///   - completion: Completion handler with Result indicating success or error
    func update(exame: ExameModel, completion: @escaping (Result<Void, ExameServiceError>) -> Void)
    
    /// Deletes an exam from the data store
    /// - Parameters:
    ///   - id: The unique identifier of the exam to delete
    ///   - completion: Completion handler with Result indicating success or error
    func delete(id: String, completion: @escaping (Result<Void, ExameServiceError>) -> Void)
    
    /// Searches exams based on a query string
    /// - Parameters:
    ///   - query: The search query
    ///   - completion: Completion handler with Result containing filtered exams or error
    func search(query: String, completion: @escaping (Result<[ExameModel], ExameServiceError>) -> Void)
    
    /// Fetches all scheduled exams (exams with dataAgendamento in the future)
    /// - Parameter completion: Completion handler with Result containing array of scheduled exams or error
    func fetchScheduledExams(completion: @escaping (Result<[ExameModel], ExameServiceError>) -> Void)
}

/// Error types for Exam Service operations
enum ExameServiceError: Error {
    case networkError
    case parsingError
    case notFound
    case unauthorized
    case invalidData
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .networkError:
            return "Erro de conexão. Verifique sua internet."
        case .parsingError:
            return "Erro ao processar dados."
        case .notFound:
            return "Exame não encontrado."
        case .unauthorized:
            return "Você não tem permissão para esta ação."
        case .invalidData:
            return "Dados inválidos."
        case .unknown(let error):
            return "Erro desconhecido: \(error.localizedDescription)"
        }
    }
}


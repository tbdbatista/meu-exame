import Foundation
import FirebaseFirestore

/// Adapter for converting between ExameModel and Firestore data format.
/// Handles special conversions for Date fields using Timestamp.
final class FirestoreAdapter {
    
    // MARK: - Firestore Keys
    
    private enum Keys {
        static let id = "id"
        static let nome = "nome"
        static let localRealizado = "localRealizado"
        static let medicoSolicitante = "medicoSolicitante"
        static let motivoQueixa = "motivoQueixa"
        static let dataCadastro = "dataCadastro"
        static let dataAgendamento = "dataAgendamento"
        static let urlArquivo = "urlArquivo"
    }
    
    // MARK: - Model to Firestore
    
    /// Converts ExameModel to Firestore dictionary format
    /// - Parameter exame: The exam model to convert
    /// - Returns: Dictionary representation suitable for Firestore
    static func toFirestore(_ exame: ExameModel) -> [String: Any] {
        var data: [String: Any] = [
            Keys.id: exame.id,
            Keys.nome: exame.nome,
            Keys.localRealizado: exame.localRealizado,
            Keys.medicoSolicitante: exame.medicoSolicitante,
            Keys.motivoQueixa: exame.motivoQueixa,
            Keys.dataCadastro: Timestamp(date: exame.dataCadastro)
        ]
        
        // Optional scheduled date - only include if not nil
        if let dataAgendamento = exame.dataAgendamento {
            data[Keys.dataAgendamento] = Timestamp(date: dataAgendamento)
        }
        
        // Optional URL - only include if not nil
        if let urlArquivo = exame.urlArquivo {
            data[Keys.urlArquivo] = urlArquivo
        }
        
        return data
    }
    
    // MARK: - Firestore to Model
    
    /// Converts Firestore document to ExameModel
    /// - Parameter document: The Firestore document snapshot
    /// - Returns: ExameModel if conversion succeeds, nil otherwise
    static func fromFirestore(_ document: DocumentSnapshot) -> ExameModel? {
        guard let data = document.data() else {
            print("⚠️ FirestoreAdapter: Document data is nil")
            return nil
        }
        
        return fromFirestore(data, documentId: document.documentID)
    }
    
    /// Converts Firestore dictionary to ExameModel
    /// - Parameters:
    ///   - data: The Firestore data dictionary
    ///   - documentId: The document ID (used as fallback if 'id' field is missing)
    /// - Returns: ExameModel if conversion succeeds, nil otherwise
    static func fromFirestore(_ data: [String: Any], documentId: String? = nil) -> ExameModel? {
        // Extract required fields
        guard let nome = data[Keys.nome] as? String,
              let localRealizado = data[Keys.localRealizado] as? String,
              let medicoSolicitante = data[Keys.medicoSolicitante] as? String,
              let motivoQueixa = data[Keys.motivoQueixa] as? String else {
            print("⚠️ FirestoreAdapter: Missing required fields")
            return nil
        }
        
        // Extract ID (use documentId as fallback)
        let id = (data[Keys.id] as? String) ?? documentId ?? UUID().uuidString
        
        // Extract and convert Date from Timestamp
        let dataCadastro: Date
        if let timestamp = data[Keys.dataCadastro] as? Timestamp {
            dataCadastro = timestamp.dateValue()
        } else if let date = data[Keys.dataCadastro] as? Date {
            // Fallback for direct Date objects (shouldn't happen in Firestore)
            dataCadastro = date
        } else {
            print("⚠️ FirestoreAdapter: Invalid dataCadastro, using current date")
            dataCadastro = Date()
        }
        
        // Extract optional scheduled date
        let dataAgendamento: Date?
        if let timestamp = data[Keys.dataAgendamento] as? Timestamp {
            dataAgendamento = timestamp.dateValue()
        } else if let date = data[Keys.dataAgendamento] as? Date {
            dataAgendamento = date
        } else {
            dataAgendamento = nil
        }
        
        // Extract optional URL
        let urlArquivo = data[Keys.urlArquivo] as? String
        
        return ExameModel(
            id: id,
            nome: nome,
            localRealizado: localRealizado,
            medicoSolicitante: medicoSolicitante,
            motivoQueixa: motivoQueixa,
            dataCadastro: dataCadastro,
            dataAgendamento: dataAgendamento,
            urlArquivo: urlArquivo
        )
    }
    
    // MARK: - Batch Conversion
    
    /// Converts multiple Firestore documents to ExameModel array
    /// - Parameter documents: Array of Firestore document snapshots
    /// - Returns: Array of ExameModel (skips invalid documents)
    static func fromFirestore(_ documents: [QueryDocumentSnapshot]) -> [ExameModel] {
        return documents.compactMap { document in
            fromFirestore(document)
        }
    }
    
    // MARK: - Validation
    
    /// Validates if the data dictionary contains all required fields
    /// - Parameter data: The data dictionary to validate
    /// - Returns: True if all required fields are present
    static func isValid(_ data: [String: Any]) -> Bool {
        return data[Keys.nome] != nil &&
               data[Keys.localRealizado] != nil &&
               data[Keys.medicoSolicitante] != nil &&
               data[Keys.motivoQueixa] != nil &&
               data[Keys.dataCadastro] != nil
    }
    
    // MARK: - Update Data
    
    /// Creates a dictionary with only the fields that should be updated
    /// - Parameter exame: The exam model with updated values
    /// - Returns: Dictionary with updatable fields
    static func toFirestoreUpdate(_ exame: ExameModel) -> [String: Any] {
        var data: [String: Any] = [
            Keys.nome: exame.nome,
            Keys.localRealizado: exame.localRealizado,
            Keys.medicoSolicitante: exame.medicoSolicitante,
            Keys.motivoQueixa: exame.motivoQueixa,
            Keys.dataCadastro: Timestamp(date: exame.dataCadastro)
        ]
        
        // Handle optional scheduled date
        if let dataAgendamento = exame.dataAgendamento {
            data[Keys.dataAgendamento] = Timestamp(date: dataAgendamento)
        } else {
            // Explicitly remove field if nil
            data[Keys.dataAgendamento] = FieldValue.delete()
        }
        
        // Handle optional URL
        if let urlArquivo = exame.urlArquivo {
            data[Keys.urlArquivo] = urlArquivo
        } else {
            // Explicitly remove field if nil
            data[Keys.urlArquivo] = FieldValue.delete()
        }
        
        return data
    }
}

// MARK: - Firestore Collection Reference Extension

extension FirestoreAdapter {
    /// The Firestore collection name for exams
    static let collectionName = "exames"
    
    /// Gets a reference to the exams collection for the current user
    /// - Parameter userId: The user ID to scope the collection
    /// - Returns: CollectionReference for user's exams
    static func examesCollection(for userId: String) -> CollectionReference {
        return Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection(collectionName)
    }
}


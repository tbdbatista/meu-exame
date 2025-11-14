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
        static let dataPronto = "dataPronto"
        static let dataAgendamento = "dataAgendamento" // Legacy - for migration
        static let urlArquivo = "urlArquivo"
        static let arquivosAnexados = "arquivosAnexados"
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
        
        // Optional dataPronto - only include if not nil
        if let dataPronto = exame.dataPronto {
            data[Keys.dataPronto] = Timestamp(date: dataPronto)
        }
        
        // Optional URL - only include if not nil (legacy)
        if let urlArquivo = exame.urlArquivo {
            data[Keys.urlArquivo] = urlArquivo
        }
        
        // Attached files array
        if !exame.arquivosAnexados.isEmpty {
            let filesData = exame.arquivosAnexados.map { file in
                [
                    "id": file.id,
                    "url": file.url,
                    "name": file.name
                ]
            }
            data[Keys.arquivosAnexados] = filesData
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
        // Migration: If dataAgendamento exists (legacy), use it as dataCadastro
        let dataCadastro: Date
        if let legacyTimestamp = data[Keys.dataAgendamento] as? Timestamp {
            // Legacy: dataAgendamento was used as the exam date
            dataCadastro = legacyTimestamp.dateValue()
        } else if let timestamp = data[Keys.dataCadastro] as? Timestamp {
            dataCadastro = timestamp.dateValue()
        } else if let date = data[Keys.dataCadastro] as? Date {
            // Fallback for direct Date objects (shouldn't happen in Firestore)
            dataCadastro = date
        } else {
            print("⚠️ FirestoreAdapter: Invalid dataCadastro, using current date")
            dataCadastro = Date()
        }
        
        // Extract optional dataPronto
        let dataPronto: Date?
        if let timestamp = data[Keys.dataPronto] as? Timestamp {
            dataPronto = timestamp.dateValue()
        } else if let date = data[Keys.dataPronto] as? Date {
            dataPronto = date
        } else {
            dataPronto = nil
        }
        
        // Extract optional URL (legacy)
        let urlArquivo = data[Keys.urlArquivo] as? String
        
        // Extract attached files array
        var arquivosAnexados: [AttachedFile] = []
        if let filesArray = data[Keys.arquivosAnexados] as? [[String: Any]] {
            arquivosAnexados = filesArray.compactMap { fileDict in
                guard let id = fileDict["id"] as? String,
                      let url = fileDict["url"] as? String,
                      let name = fileDict["name"] as? String else {
                    return nil
                }
                return AttachedFile(id: id, url: url, name: name)
            }
        }
        
        return ExameModel(
            id: id,
            nome: nome,
            localRealizado: localRealizado,
            medicoSolicitante: medicoSolicitante,
            motivoQueixa: motivoQueixa,
            dataCadastro: dataCadastro,
            dataPronto: dataPronto,
            arquivosAnexados: arquivosAnexados,
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
        
        // Handle optional dataPronto
        if let dataPronto = exame.dataPronto {
            data[Keys.dataPronto] = Timestamp(date: dataPronto)
        } else {
            // Explicitly remove field if nil
            data[Keys.dataPronto] = FieldValue.delete()
        }
        
        // Handle optional URL (legacy)
        if let urlArquivo = exame.urlArquivo {
            data[Keys.urlArquivo] = urlArquivo
        } else {
            // Explicitly remove field if nil
            data[Keys.urlArquivo] = FieldValue.delete()
        }
        
        // Handle attached files array
        if !exame.arquivosAnexados.isEmpty {
            let filesData = exame.arquivosAnexados.map { file in
                [
                    "id": file.id,
                    "url": file.url,
                    "name": file.name
                ]
            }
            data[Keys.arquivosAnexados] = filesData
        } else {
            data[Keys.arquivosAnexados] = FieldValue.delete()
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


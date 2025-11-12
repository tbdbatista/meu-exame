import Foundation
import FirebaseAuth

/// ExameDetailInteractor é o Interactor da tela de detalhes do exame.
/// Segue o padrão VIPER, gerenciando a lógica de negócios e comunicação com serviços.
final class ExameDetailInteractor {
    
    // MARK: - VIPER Properties (Base Protocol)
    
    weak var presenter: PresenterProtocol?
    
    // MARK: - Private Properties
    
    weak var output: ExameDetailInteractorOutputProtocol?
    private let exameService: ExamesServiceProtocol
    private let storageService: StorageServiceProtocol
    
    // MARK: - Initializer
    
    init(exameService: ExamesServiceProtocol, storageService: StorageServiceProtocol) {
        self.exameService = exameService
        self.storageService = storageService
    }
}

// MARK: - InteractorProtocol

extension ExameDetailInteractor: InteractorProtocol {
    // Base protocol conformance
}

// MARK: - ExameDetailInteractorProtocol

extension ExameDetailInteractor: ExameDetailInteractorProtocol {
    func fetchExam(examId: String) {
        print("📥 ExameDetailInteractor: Buscando exame: \(examId)")
        
        exameService.fetchById(id: examId) { [weak self] result in
            switch result {
            case .success(let exame):
                print("✅ ExameDetailInteractor: Exame encontrado")
                self?.output?.examDidLoad(exame)
                
            case .failure(let error):
                print("❌ ExameDetailInteractor: Erro ao buscar exame - \(error.localizedDescription)")
                self?.output?.examLoadDidFail(error: error)
            }
        }
    }
    
    func updateExam(_ exame: ExameModel, fileData: Data?, fileName: String?, shouldDeleteOldFile: Bool) {
        print("💾 ExameDetailInteractor: Atualizando exame: \(exame.nome)")
        print("📎 Dados de arquivo: \(fileData != nil ? "Sim" : "Não"), Nome: \(fileName ?? "N/A"), Deletar antigo: \(shouldDeleteOldFile)")
        
        // If file data provided, upload it first
        if let fileData = fileData, let fileName = fileName {
            uploadFileAndUpdateExam(exame: exame, fileData: fileData, fileName: fileName, shouldDeleteOldFile: shouldDeleteOldFile)
        } else if shouldDeleteOldFile {
            // File was removed, delete from storage and update exam without file
            deleteOldFileAndUpdateExam(exame: exame)
        } else {
            // No file changes, just update exam data
            updateExamInFirestore(exame)
        }
    }
    
    private func uploadFileAndUpdateExam(exame: ExameModel, fileData: Data, fileName: String, shouldDeleteOldFile: Bool) {
        guard let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "ExameDetail", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado"])
            output?.examUpdateDidFail(error: error)
            return
        }
        
        // Extract file extension
        let fileExtension = (fileName as NSString).pathExtension
        
        // Create friendly file name: ExameName.extension
        let friendlyFileName: String
        if !fileExtension.isEmpty {
            friendlyFileName = "\(exame.nome).\(fileExtension)"
        } else {
            friendlyFileName = "\(exame.nome).pdf" // Default to PDF if no extension
        }
        
        // Storage path: exames/userId/examId_friendlyFileName
        let storagePath = "exames/\(userId)/\(exame.id)_\(friendlyFileName)"
        
        print("📤 Uploading file to: \(storagePath)")
        
        // Delete old file first if it exists
        if shouldDeleteOldFile {
            deleteOldFileBeforeUpload(examId: exame.id) { [weak self] in
                self?.performFileUpload(fileData: fileData, storagePath: storagePath, exame: exame, friendlyFileName: friendlyFileName)
            }
        } else {
            performFileUpload(fileData: fileData, storagePath: storagePath, exame: exame, friendlyFileName: friendlyFileName)
        }
    }
    
    private func performFileUpload(fileData: Data, storagePath: String, exame: ExameModel, friendlyFileName: String) {
        storageService.upload(data: fileData, to: storagePath) { [weak self] result in
            switch result {
            case .success(let downloadURL):
                print("✅ File uploaded successfully: \(downloadURL)")
                
                // Create updated exam with new file URL and name
                let updatedExame = ExameModel(
                    id: exame.id,
                    nome: exame.nome,
                    localRealizado: exame.localRealizado,
                    medicoSolicitante: exame.medicoSolicitante,
                    motivoQueixa: exame.motivoQueixa,
                    dataCadastro: exame.dataCadastro,
                    urlArquivo: downloadURL,
                    nomeArquivo: friendlyFileName
                )
                
                self?.updateExamInFirestore(updatedExame)
                
            case .failure(let error):
                print("❌ File upload failed: \(error.localizedDescription)")
                self?.output?.examUpdateDidFail(error: error)
            }
        }
    }
    
    private func deleteOldFileBeforeUpload(examId: String, completion: @escaping () -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion()
            return
        }
        
        // We don't have the exact file name, so we'll just continue with upload
        // The old file will remain in storage but won't be referenced
        // TODO: Implement proper file tracking or cleanup
        print("⚠️ Old file cleanup not fully implemented, continuing with upload")
        completion()
    }
    
    private func deleteOldFileAndUpdateExam(exame: ExameModel) {
        // File was removed, just update exam without file URL
        print("🗑️ Removing file reference from exam")
        updateExamInFirestore(exame) // Exam already has nil urlArquivo and nomeArquivo
    }
    
    private func updateExamInFirestore(_ exame: ExameModel) {
        exameService.update(exame: exame) { [weak self] result in
            switch result {
            case .success:
                print("✅ ExameDetailInteractor: Exame atualizado no Firestore")
                self?.output?.examDidUpdate(exame)
                
            case .failure(let error):
                print("❌ ExameDetailInteractor: Erro ao atualizar no Firestore - \(error.localizedDescription)")
                self?.output?.examUpdateDidFail(error: error)
            }
        }
    }
    
    func deleteExam(examId: String) {
        print("🗑️ ExameDetailInteractor: Deletando exame: \(examId)")
        
        exameService.delete(id: examId) { [weak self] result in
            switch result {
            case .success:
                print("✅ ExameDetailInteractor: Exame deletado")
                self?.output?.examDidDelete()
                
            case .failure(let error):
                print("❌ ExameDetailInteractor: Erro ao deletar - \(error.localizedDescription)")
                self?.output?.examDeleteDidFail(error: error)
            }
        }
    }
    
    func downloadFile(url: String) {
        print("📥 ExameDetailInteractor: Baixando arquivo: \(url)")
        
        // TODO: Implement file download from Firebase Storage
        // For now, just pass the URL
        guard let fileURL = URL(string: url) else {
            let error = NSError(domain: "ExameDetail", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL inválida"])
            output?.fileDownloadDidFail(error: error)
            return
        }
        
        output?.fileDidDownload(fileURL: fileURL)
    }
}


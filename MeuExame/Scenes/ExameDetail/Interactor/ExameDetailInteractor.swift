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
    private let notificationService: NotificationServiceProtocol
    private var originalExame: ExameModel?
    
    // MARK: - Initializer
    
    init(exameService: ExamesServiceProtocol, storageService: StorageServiceProtocol, notificationService: NotificationServiceProtocol) {
        self.exameService = exameService
        self.storageService = storageService
        self.notificationService = notificationService
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
                self?.originalExame = exame
                self?.output?.examDidLoad(exame)
                
            case .failure(let error):
                print("❌ ExameDetailInteractor: Erro ao buscar exame - \(error.localizedDescription)")
                self?.output?.examLoadDidFail(error: error)
            }
        }
    }
    
    func updateExam(_ exame: ExameModel, newFiles: [(Data, String)]) {
        print("💾 ExameDetailInteractor: Atualizando exame: \(exame.nome)")
        print("📎 Novos arquivos: \(newFiles.count)")
        
        // If no new files, just update exam data
        guard !newFiles.isEmpty else {
            updateExamInFirestore(exame)
            return
        }
        
        // Upload new files
        uploadMultipleFilesAndUpdateExam(exame: exame, newFiles: newFiles)
    }
    
    private func uploadMultipleFilesAndUpdateExam(exame: ExameModel, newFiles: [(Data, String)]) {
        guard let userId = Auth.auth().currentUser?.uid else {
            let error = NSError(domain: "ExameDetail", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado"])
            output?.examUpdateDidFail(error: error)
            return
        }
        
        var uploadedFiles: [AttachedFile] = []
        let group = DispatchGroup()
        var uploadError: Error?
        
        for (fileData, fileName) in newFiles {
            group.enter()
            
            // Extract file extension
            let fileExtension = (fileName as NSString).pathExtension
            
            // Create friendly file name with counter if multiple files
            let fileIndex = newFiles.firstIndex(where: { $0.1 == fileName }) ?? 0
            let friendlyFileName: String
            if newFiles.count > 1 {
                if !fileExtension.isEmpty {
                    friendlyFileName = "\(exame.nome)-\(fileIndex + 1).\(fileExtension)"
                } else {
                    friendlyFileName = "\(exame.nome)-\(fileIndex + 1).pdf"
                }
            } else {
                if !fileExtension.isEmpty {
                    friendlyFileName = "\(exame.nome).\(fileExtension)"
                } else {
                    friendlyFileName = "\(exame.nome).pdf"
                }
            }
            
            // Storage path: exames/userId/examId_friendlyFileName_timestamp
            let timestamp = Date().timeIntervalSince1970
            let storagePath = "exames/\(userId)/\(exame.id)_\(friendlyFileName)_\(Int(timestamp))"
            
            print("📤 Uploading file \(fileIndex + 1)/\(newFiles.count): \(storagePath)")
            
            storageService.upload(data: fileData, to: storagePath) { result in
                switch result {
                case .success(let downloadURL):
                    print("✅ File uploaded: \(friendlyFileName)")
                    uploadedFiles.append(AttachedFile(url: downloadURL, name: friendlyFileName))
                    
                case .failure(let error):
                    print("❌ File upload failed: \(error.localizedDescription)")
                    if uploadError == nil {
                        uploadError = error
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            if let error = uploadError {
                print("❌ Some files failed to upload")
                self?.output?.examUpdateDidFail(error: error)
                return
            }
            
            // Create updated exam with existing + new files
            let allFiles = exame.arquivosAnexados + uploadedFiles
            let updatedExame = ExameModel(
                id: exame.id,
                nome: exame.nome,
                localRealizado: exame.localRealizado,
                medicoSolicitante: exame.medicoSolicitante,
                motivoQueixa: exame.motivoQueixa,
                dataCadastro: exame.dataCadastro,
                dataAgendamento: exame.dataAgendamento,
                arquivosAnexados: allFiles
            )
            
            self?.updateExamInFirestore(updatedExame)
        }
    }
    
    private func updateExamInFirestore(_ exame: ExameModel) {
        exameService.update(exame: exame) { [weak self] result in
            switch result {
            case .success:
                print("✅ ExameDetailInteractor: Exame atualizado no Firestore")
                
                // Handle notifications: cancel old, schedule new if needed
                self?.handleNotificationUpdate(oldExame: self?.originalExame, newExame: exame)
                self?.originalExame = exame
                
                self?.output?.examDidUpdate(exame)
                
            case .failure(let error):
                print("❌ ExameDetailInteractor: Erro ao atualizar no Firestore - \(error.localizedDescription)")
                self?.output?.examUpdateDidFail(error: error)
            }
        }
    }
    
    private func handleNotificationUpdate(oldExame: ExameModel?, newExame: ExameModel) {
        // Cancel old notification if existed
        if let oldExame = oldExame, oldExame.dataAgendamento != nil {
            notificationService.cancelExamNotification(examId: oldExame.id)
        }
        
        // Schedule new notification if exam has scheduled date in the future
        if let dataAgendamento = newExame.dataAgendamento, dataAgendamento > Date() {
            scheduleNotification(for: newExame)
        }
    }
    
    private func scheduleNotification(for exame: ExameModel) {
        guard let dataAgendamento = exame.dataAgendamento else { return }
        
        notificationService.requestAuthorization { [weak self] granted, error in
            if let error = error {
                print("⚠️ ExameDetailInteractor: Erro ao solicitar permissão de notificação: \(error.localizedDescription)")
                return
            }
            
            if granted {
                self?.notificationService.scheduleExamNotification(
                    examId: exame.id,
                    examName: exame.nome,
                    scheduledDate: dataAgendamento
                ) { result in
                    switch result {
                    case .success:
                        print("✅ ExameDetailInteractor: Notificação agendada com sucesso")
                    case .failure(let error):
                        print("⚠️ ExameDetailInteractor: Erro ao agendar notificação: \(error.localizedDescription)")
                    }
                }
            } else {
                print("⚠️ ExameDetailInteractor: Permissão de notificação negada")
            }
        }
    }
    
    func deleteExam(examId: String) {
        print("🗑️ ExameDetailInteractor: Deletando exame: \(examId)")
        
        // Cancel notification if exam was scheduled
        if let originalExame = originalExame, originalExame.dataAgendamento != nil {
            notificationService.cancelExamNotification(examId: examId)
        }
        
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


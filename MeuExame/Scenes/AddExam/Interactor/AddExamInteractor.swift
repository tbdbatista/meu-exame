import Foundation
import FirebaseAuth

/// AddExamInteractor é o Interactor da tela de cadastro de exames.
/// Segue o padrão VIPER, gerenciando a lógica de negócios e comunicação com serviços.
final class AddExamInteractor {
    
    // MARK: - VIPER Properties (Base Protocol)
    
    weak var presenter: PresenterProtocol?
    
    // MARK: - Private Properties
    
    weak var output: AddExamInteractorOutputProtocol?
    private let exameService: ExamesServiceProtocol
    private let storageService: StorageServiceProtocol
    private let notificationService: NotificationServiceProtocol
    
    // MARK: - Initializer
    
    init(exameService: ExamesServiceProtocol, storageService: StorageServiceProtocol, notificationService: NotificationServiceProtocol) {
        self.exameService = exameService
        self.storageService = storageService
        self.notificationService = notificationService
    }
}

// MARK: - InteractorProtocol

extension AddExamInteractor: InteractorProtocol {
    // Base protocol conformance
}

// MARK: - AddExamInteractorProtocol

extension AddExamInteractor: AddExamInteractorProtocol {
    func createExam(exame: ExameModel, isScheduled: Bool, fileData: Data?, fileName: String?) {
        print("📝 AddExamInteractor: Criando exame '\(exame.nome)' (agendado: \(isScheduled))")
        
        // Check if there's a file to upload
        if let fileData = fileData, let fileName = fileName {
            print("📤 AddExamInteractor: Arquivo anexado, iniciando upload")
            uploadFileAndCreateExam(exame: exame, isScheduled: isScheduled, fileData: fileData, fileName: fileName)
        } else {
            print("📝 AddExamInteractor: Sem arquivo anexado")
            createExamInFirestore(exame, isScheduled: isScheduled)
        }
    }
    
    // MARK: - Private Methods
    
    private func uploadFileAndCreateExam(exame: ExameModel, isScheduled: Bool, fileData: Data, fileName: String) {
        // Get current user ID for storage path
        guard let userId = Auth.auth().currentUser?.uid else {
            print("❌ AddExamInteractor: Usuário não autenticado")
            output?.examCreateDidFail(error: NSError(
                domain: "AddExamInteractor",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado"]
            ))
            return
        }
        
        // Extract file extension from original file name
        let fileExtension = (fileName as NSString).pathExtension
        
        // Create friendly file name: ExameName.extension
        let friendlyFileName: String
        if !fileExtension.isEmpty {
            friendlyFileName = "\(exame.nome).\(fileExtension)"
        } else {
            friendlyFileName = "\(exame.nome).pdf" // Default to .pdf if no extension
        }
        
        // Create storage path: exames/userId/examId_friendlyFileName
        let storagePath = "exames/\(userId)/\(exame.id)_\(friendlyFileName)"
        print("📤 AddExamInteractor: Uploading para: \(storagePath)")
        print("📄 AddExamInteractor: Nome amigável: \(friendlyFileName)")
        
        // Upload file to Firebase Storage
        storageService.upload(data: fileData, to: storagePath) { [weak self] result in
            switch result {
            case .success(let downloadURL):
                print("✅ AddExamInteractor: Upload concluído: \(downloadURL)")
                
                // Create updated exam model with file URL and friendly file name
                let updatedExame = ExameModel(
                    id: exame.id,
                    nome: exame.nome,
                    localRealizado: exame.localRealizado,
                    medicoSolicitante: exame.medicoSolicitante,
                    motivoQueixa: exame.motivoQueixa,
                    dataCadastro: exame.dataCadastro,
                    urlArquivo: downloadURL,
                    nomeArquivo: friendlyFileName // Use exam name + extension
                )
                
                // Now create exam in Firestore with file URL
                self?.createExamInFirestore(updatedExame, isScheduled: isScheduled)
                
            case .failure(let error):
                print("❌ AddExamInteractor: Erro no upload - \(error.localizedDescription)")
                self?.output?.examCreateDidFail(error: error)
            }
        }
    }
    
    private func createExamInFirestore(_ exame: ExameModel, isScheduled: Bool) {
        exameService.create(exame: exame) { [weak self] result in
            switch result {
            case .success(let createdExame):
                print("✅ AddExamInteractor: Exame criado no Firestore")
                print("📄 AddExamInteractor: URL do arquivo: \(createdExame.urlArquivo ?? "nenhum")")
                
                // Schedule notification only if exam is scheduled (future date)
                if isScheduled && createdExame.dataCadastro > Date() {
                    print("📅 AddExamInteractor: Agendando notificação para \(createdExame.dataCadastro)")
                    self?.scheduleNotification(for: createdExame)
                }
                
                self?.output?.examDidCreate(createdExame)
                
            case .failure(let error):
                print("❌ AddExamInteractor: Erro ao criar exame - \(error.localizedDescription)")
                self?.output?.examCreateDidFail(error: error)
            }
        }
    }
    
    private func scheduleNotification(for exame: ExameModel) {
        // Only schedule if exam is in the future
        guard exame.dataCadastro > Date() else { return }
        
        notificationService.requestAuthorization { [weak self] granted, error in
            if let error = error {
                print("⚠️ AddExamInteractor: Erro ao solicitar permissão de notificação: \(error.localizedDescription)")
                return
            }
            
            if granted {
                self?.notificationService.scheduleExamNotification(
                    examId: exame.id,
                    examName: exame.nome,
                    scheduledDate: exame.dataCadastro
                ) { result in
                    switch result {
                    case .success:
                        print("✅ AddExamInteractor: Notificação agendada com sucesso")
                    case .failure(let error):
                        print("⚠️ AddExamInteractor: Erro ao agendar notificação: \(error.localizedDescription)")
                    }
                }
            } else {
                print("⚠️ AddExamInteractor: Permissão de notificação negada")
            }
        }
    }
}


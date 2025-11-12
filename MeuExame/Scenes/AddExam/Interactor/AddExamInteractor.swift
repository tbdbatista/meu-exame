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
    
    // MARK: - Initializer
    
    init(exameService: ExamesServiceProtocol, storageService: StorageServiceProtocol) {
        self.exameService = exameService
        self.storageService = storageService
    }
}

// MARK: - InteractorProtocol

extension AddExamInteractor: InteractorProtocol {
    // Base protocol conformance
}

// MARK: - AddExamInteractorProtocol

extension AddExamInteractor: AddExamInteractorProtocol {
    func createExam(exame: ExameModel, fileData: Data?, fileName: String?) {
        print("📝 AddExamInteractor: Criando exame '\(exame.nome)'")
        
        // Check if there's a file to upload
        if let fileData = fileData, let fileName = fileName {
            print("📤 AddExamInteractor: Arquivo anexado, iniciando upload")
            uploadFileAndCreateExam(exame: exame, fileData: fileData, fileName: fileName)
        } else {
            print("📝 AddExamInteractor: Sem arquivo anexado")
            createExamInFirestore(exame)
        }
    }
    
    // MARK: - Private Methods
    
    private func uploadFileAndCreateExam(exame: ExameModel, fileData: Data, fileName: String) {
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
        
        // Create storage path: exames/userId/examId_fileName
        let storagePath = "exames/\(userId)/\(exame.id)_\(fileName)"
        print("📤 AddExamInteractor: Uploading para: \(storagePath)")
        
        // Upload file to Firebase Storage
        storageService.upload(data: fileData, to: storagePath) { [weak self] result in
            switch result {
            case .success(let downloadURL):
                print("✅ AddExamInteractor: Upload concluído: \(downloadURL)")
                
                // Create updated exam model with file URL and original file name
                let updatedExame = ExameModel(
                    id: exame.id,
                    nome: exame.nome,
                    localRealizado: exame.localRealizado,
                    medicoSolicitante: exame.medicoSolicitante,
                    motivoQueixa: exame.motivoQueixa,
                    dataCadastro: exame.dataCadastro,
                    urlArquivo: downloadURL,
                    nomeArquivo: fileName // Save original file name
                )
                
                // Now create exam in Firestore with file URL
                self?.createExamInFirestore(updatedExame)
                
            case .failure(let error):
                print("❌ AddExamInteractor: Erro no upload - \(error.localizedDescription)")
                self?.output?.examCreateDidFail(error: error)
            }
        }
    }
    
    private func createExamInFirestore(_ exame: ExameModel) {
        exameService.create(exame: exame) { [weak self] result in
            switch result {
            case .success(let createdExame):
                print("✅ AddExamInteractor: Exame criado no Firestore")
                print("📄 AddExamInteractor: URL do arquivo: \(createdExame.urlArquivo ?? "nenhum")")
                self?.output?.examDidCreate(createdExame)
                
            case .failure(let error):
                print("❌ AddExamInteractor: Erro ao criar exame - \(error.localizedDescription)")
                self?.output?.examCreateDidFail(error: error)
            }
        }
    }
}


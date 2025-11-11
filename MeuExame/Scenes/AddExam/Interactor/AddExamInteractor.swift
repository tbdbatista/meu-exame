import Foundation

/// AddExamInteractor é o Interactor da tela de cadastro de exames.
/// Segue o padrão VIPER, gerenciando a lógica de negócios e comunicação com serviços.
final class AddExamInteractor {
    
    // MARK: - VIPER Properties (Base Protocol)
    
    weak var presenter: PresenterProtocol?
    
    // MARK: - Private Properties
    
    weak var output: AddExamInteractorOutputProtocol?
    private let exameService: ExamesServiceProtocol
    
    // TODO: Inject StorageService when implemented
    // private let storageService: StorageServiceProtocol
    
    // MARK: - Initializer
    
    init(exameService: ExamesServiceProtocol) {
        self.exameService = exameService
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
            print("📤 AddExamInteractor: Arquivo anexado, upload necessário")
            // TODO: Upload file to Firebase Storage first
            // For now, create exam without file URL
            createExamInFirestore(exame)
        } else {
            print("📝 AddExamInteractor: Sem arquivo anexado")
            createExamInFirestore(exame)
        }
    }
    
    // MARK: - Private Methods
    
    private func createExamInFirestore(_ exame: ExameModel) {
        exameService.create(exame: exame) { [weak self] result in
            switch result {
            case .success(let createdExame):
                print("✅ AddExamInteractor: Exame criado no Firestore")
                self?.output?.examDidCreate(createdExame)
                
            case .failure(let error):
                print("❌ AddExamInteractor: Erro ao criar exame - \(error.localizedDescription)")
                self?.output?.examCreateDidFail(error: error)
            }
        }
    }
    
    // TODO: Implement file upload when StorageService is ready
    /*
    private func uploadFile(_ data: Data, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        print("📤 AddExamInteractor: Uploading file: \(fileName)")
        
        storageService.uploadFile(data: data, fileName: fileName, path: "exames") { [weak self] result in
            switch result {
            case .success(let url):
                print("✅ AddExamInteractor: File uploaded: \(url)")
                completion(.success(url))
                
            case .failure(let error):
                print("❌ AddExamInteractor: Upload failed - \(error.localizedDescription)")
                completion(.failure(error))
            }
        }
    }
    */
}


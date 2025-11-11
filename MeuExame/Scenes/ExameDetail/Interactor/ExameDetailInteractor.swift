import Foundation

/// ExameDetailInteractor é o Interactor da tela de detalhes do exame.
/// Segue o padrão VIPER, gerenciando a lógica de negócios e comunicação com serviços.
final class ExameDetailInteractor {
    
    // MARK: - VIPER Properties (Base Protocol)
    
    weak var presenter: PresenterProtocol?
    
    // MARK: - Private Properties
    
    weak var output: ExameDetailInteractorOutputProtocol?
    private let exameService: ExamesServiceProtocol
    
    // TODO: Inject StorageService when implemented
    // private let storageService: StorageServiceProtocol
    
    // MARK: - Initializer
    
    init(exameService: ExamesServiceProtocol) {
        self.exameService = exameService
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
    
    func updateExam(_ exame: ExameModel) {
        print("💾 ExameDetailInteractor: Atualizando exame: \(exame.nome)")
        
        exameService.update(exame: exame) { [weak self] result in
            switch result {
            case .success:
                print("✅ ExameDetailInteractor: Exame atualizado")
                self?.output?.examDidUpdate(exame)
                
            case .failure(let error):
                print("❌ ExameDetailInteractor: Erro ao atualizar - \(error.localizedDescription)")
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


import Foundation

/// ScheduledExamsListInteractor é o Interactor da tela de listagem de exames agendados.
/// Segue o padrão VIPER, gerenciando a lógica de negócios e comunicação com serviços.
final class ScheduledExamsListInteractor {
    
    // MARK: - VIPER Properties (Base Protocol)
    
    weak var presenter: PresenterProtocol?
    
    // MARK: - Private Properties
    
    weak var output: ScheduledExamsListInteractorOutputProtocol?
    private let exameService: ExamesServiceProtocol
    
    // MARK: - Initializer
    
    init(exameService: ExamesServiceProtocol) {
        self.exameService = exameService
    }
}

// MARK: - InteractorProtocol

extension ScheduledExamsListInteractor: InteractorProtocol {
    // Base protocol conformance
}

// MARK: - ScheduledExamsListInteractorProtocol

extension ScheduledExamsListInteractor: ScheduledExamsListInteractorProtocol {
    func fetchScheduledExams() {
        print("🔄 ScheduledExamsListInteractor: Buscando exames agendados do Firestore...")
        
        exameService.fetchScheduledExams { [weak self] result in
            switch result {
            case .success(let exames):
                print("✅ ScheduledExamsListInteractor: \(exames.count) exames agendados carregados")
                self?.output?.scheduledExamsDidLoad(exames)
            case .failure(let error):
                print("❌ ScheduledExamsListInteractor: Erro ao buscar exames agendados - \(error.localizedDescription)")
                self?.output?.scheduledExamsDidFail(error: error)
            }
        }
    }
}


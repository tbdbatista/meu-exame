import Foundation

/// ExamesListInteractor é o Interactor da tela de listagem de exames.
/// Segue o padrão VIPER, gerenciando a lógica de negócios e comunicação com serviços.
final class ExamesListInteractor {
    
    // MARK: - VIPER Properties (Base Protocol)
    
    weak var presenter: PresenterProtocol?
    
    // MARK: - Private Properties
    
    weak var output: ExamesListInteractorOutputProtocol?
    private let exameService: ExamesServiceProtocol
    
    // MARK: - Initializer
    
    init(exameService: ExamesServiceProtocol) {
        self.exameService = exameService
    }
}

// MARK: - InteractorProtocol

extension ExamesListInteractor: InteractorProtocol {
    // Base protocol conformance
}

// MARK: - ExamesListInteractorProtocol

extension ExamesListInteractor: ExamesListInteractorProtocol {
    func fetchExames() {
        print("🔄 ExamesListInteractor: Buscando exames do Firestore...")
        
        exameService.fetch { [weak self] result in
            switch result {
            case .success(let exames):
                print("✅ ExamesListInteractor: \(exames.count) exames carregados")
                self?.output?.examesDidLoad(exames)
            case .failure(let error):
                print("❌ ExamesListInteractor: Erro ao buscar exames - \(error.localizedDescription)")
                self?.output?.examesDidFail(error: error)
            }
        }
    }
    
    func searchExames(with query: String) {
        print("🔍 ExamesListInteractor: Buscando com query: \(query)")
        
        exameService.search(query: query) { [weak self] result in
            switch result {
            case .success(let exames):
                print("✅ ExamesListInteractor: \(exames.count) resultados encontrados")
                self?.output?.searchResultsDidLoad(exames)
            case .failure(let error):
                print("❌ ExamesListInteractor: Erro na busca - \(error.localizedDescription)")
                self?.output?.examesDidFail(error: error)
            }
        }
    }
    
    func deleteExame(_ exam: ExameModel) {
        print("🗑️ ExamesListInteractor: Deletando exame: \(exam.nome)")
        
        exameService.delete(id: exam.id) { [weak self] result in
            switch result {
            case .success:
                print("✅ ExamesListInteractor: Exame deletado com sucesso")
                self?.output?.exameDidDelete(exam)
            case .failure(let error):
                print("❌ ExamesListInteractor: Erro ao deletar - \(error.localizedDescription)")
                self?.output?.exameDeleteDidFail(error: error)
            }
        }
    }
    
    // MARK: - Mock Data
    
    private func generateMockExames() -> [ExameModel] {
        return [
            ExameModel(
                id: "1",
                nome: "Hemograma Completo",
                localRealizado: "Laboratório São Lucas",
                medicoSolicitante: "Dr. João Silva",
                motivoQueixa: "Check-up de rotina",
                dataCadastro: Date().addingTimeInterval(-60*60*24*30), // 30 dias atrás
                urlArquivo: "https://example.com/exame1.pdf"
            ),
            ExameModel(
                id: "2",
                nome: "Raio-X Tórax",
                localRealizado: "Clínica Imagem Total",
                medicoSolicitante: "Dra. Maria Santos",
                motivoQueixa: "Dor no peito",
                dataCadastro: Date().addingTimeInterval(-60*60*24*15), // 15 dias atrás
                urlArquivo: nil
            ),
            ExameModel(
                id: "3",
                nome: "Ultrassom Abdominal",
                localRealizado: "Hospital Central",
                medicoSolicitante: "Dr. Pedro Oliveira",
                motivoQueixa: "Dor abdominal",
                dataCadastro: Date().addingTimeInterval(-60*60*24*7), // 7 dias atrás
                urlArquivo: "https://example.com/exame3.pdf"
            ),
            ExameModel(
                id: "4",
                nome: "Exame de Urina",
                localRealizado: "Laboratório Santa Cruz",
                medicoSolicitante: "Dr. João Silva",
                motivoQueixa: "Infecção urinária",
                dataCadastro: Date().addingTimeInterval(-60*60*24*3), // 3 dias atrás
                urlArquivo: nil
            ),
            ExameModel(
                id: "5",
                nome: "Ressonância Magnética Lombar",
                localRealizado: "Centro de Diagnóstico Avançado",
                medicoSolicitante: "Dr. Carlos Mendes",
                motivoQueixa: "Dor lombar crônica",
                dataCadastro: Date().addingTimeInterval(-60*60*24*1), // 1 dia atrás
                urlArquivo: "https://example.com/exame5.pdf"
            )
        ]
    }
}


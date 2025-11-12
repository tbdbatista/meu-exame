import Foundation

/// ExameDetailPresenter é o Presenter da tela de detalhes do exame.
/// Segue o padrão VIPER, mediando a comunicação entre View, Interactor e Router.
final class ExameDetailPresenter {
    
    // MARK: - VIPER Properties (Base Protocols)
    
    weak var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    
    // MARK: - Private Properties
    
    private var currentExame: ExameModel?
    private var isEditMode = false
    
    // MARK: - Private Helpers
    
    private var exameDetailView: ExameDetailViewProtocol? {
        return view as? ExameDetailViewProtocol
    }
    
    private var exameDetailInteractor: ExameDetailInteractorProtocol? {
        return interactor as? ExameDetailInteractorProtocol
    }
    
    private var exameDetailRouter: ExameDetailRouterProtocol? {
        return router as? ExameDetailRouterProtocol
    }
}

// MARK: - PresenterProtocol

extension ExameDetailPresenter: PresenterProtocol {
    func viewDidLoad() {
        print("📄 ExameDetailPresenter: View carregada")
        if let exame = currentExame {
            exameDetailView?.updateExamInfo(exame)
        }
    }
    
    func viewWillAppear() {
        print("📄 ExameDetailPresenter: View irá aparecer")
    }
}

// MARK: - ExameDetailPresenterProtocol

extension ExameDetailPresenter: ExameDetailPresenterProtocol {
    func didTapEdit() {
        print("✏️ ExameDetailPresenter: Modo edição ativado")
        isEditMode = true
        exameDetailView?.showEditMode()
    }
    
    func didTapDelete() {
        print("🗑️ ExameDetailPresenter: Solicitar exclusão")
        
        exameDetailRouter?.showDeleteConfirmation { [weak self] in
            guard let self = self, let exame = self.currentExame else { return }
            
            print("🗑️ ExameDetailPresenter: Exclusão confirmada")
            self.view?.showLoading()
            self.exameDetailInteractor?.deleteExam(examId: exame.id)
        }
    }
    
    func didTapSave(nome: String?, local: String?, medico: String?, motivo: String?, data: Date, newFiles: [(Data, String)]) {
        print("💾 ExameDetailPresenter: Salvar alterações")
        
        guard let currentExame = currentExame else {
            print("❌ ExameDetailPresenter: Exame atual não encontrado")
            return
        }
        
        // Validate input
        guard let nome = nome, !nome.isEmpty,
              let local = local, !local.isEmpty,
              let medico = medico, !medico.isEmpty,
              let motivo = motivo, !motivo.isEmpty else {
            view?.showError(title: "Campos Obrigatórios", message: "Preencha todos os campos")
            return
        }
        
        // Create updated exam preserving existing files
        let updatedExame = ExameModel(
            id: currentExame.id,
            nome: nome,
            localRealizado: local,
            medicoSolicitante: medico,
            motivoQueixa: motivo,
            dataCadastro: data,
            arquivosAnexados: currentExame.arquivosAnexados  // Keep existing files
        )
        
        print("💾 ExameDetailPresenter: Atualizando exame: \(updatedExame.nome)")
        print("📎 Novos arquivos: \(newFiles.count)")
        
        view?.showLoading()
        exameDetailInteractor?.updateExam(updatedExame, newFiles: newFiles)
    }
    
    func didTapCancel() {
        print("🚫 ExameDetailPresenter: Cancelar edição")
        isEditMode = false
        exameDetailView?.showViewMode()
    }
    
    func didTapViewFile(url: String) {
        print("📎 ExameDetailPresenter: Visualizar arquivo: \(url)")
        
        guard let fileURL = URL(string: url) else {
            view?.showError(title: "Erro", message: "URL do arquivo inválida")
            return
        }
        
        exameDetailRouter?.showFileViewer(fileURL: fileURL)
    }
    
    func didTapRemoveFile(at index: Int) {
        print("🗑️ ExameDetailPresenter: Remover arquivo no índice: \(index)")
        
        guard var currentExame = currentExame else { return }
        guard index < currentExame.arquivosAnexados.count else { return }
        
        // Remove file from array
        var files = currentExame.arquivosAnexados
        files.remove(at: index)
        
        // Create updated exam without the removed file
        let updatedExame = ExameModel(
            id: currentExame.id,
            nome: currentExame.nome,
            localRealizado: currentExame.localRealizado,
            medicoSolicitante: currentExame.medicoSolicitante,
            motivoQueixa: currentExame.motivoQueixa,
            dataCadastro: currentExame.dataCadastro,
            arquivosAnexados: files
        )
        
        // Update locally and inform interactor
        self.currentExame = updatedExame
        view?.showLoading()
        exameDetailInteractor?.updateExam(updatedExame, newFiles: [])
    }
    
    func didTapShare() {
        print("📤 ExameDetailPresenter: Compartilhar exame")
        
        guard let exame = currentExame else { return }
        
        let text = """
        Exame: \(exame.nome)
        Local: \(exame.localRealizado)
        Médico: \(exame.medicoSolicitante)
        Data: \(exame.dataFormatada)
        """
        
        exameDetailRouter?.showShareSheet(items: [text])
    }
}

// MARK: - ExameDetailInteractorOutputProtocol

extension ExameDetailPresenter: ExameDetailInteractorOutputProtocol {
    func examDidLoad(_ exame: ExameModel) {
        print("✅ ExameDetailPresenter: Exame carregado: \(exame.nome)")
        view?.hideLoading()
        currentExame = exame
        exameDetailView?.updateExamInfo(exame)
    }
    
    func examLoadDidFail(error: Error) {
        print("❌ ExameDetailPresenter: Erro ao carregar exame: \(error.localizedDescription)")
        view?.hideLoading()
        view?.showError(
            title: "Erro ao Carregar",
            message: "Não foi possível carregar o exame."
        )
    }
    
    func examDidUpdate(_ exame: ExameModel) {
        print("✅ ExameDetailPresenter: Exame atualizado: \(exame.nome)")
        view?.hideLoading()
        currentExame = exame
        isEditMode = false
        exameDetailView?.showViewMode()
        exameDetailView?.updateExamInfo(exame)
        view?.showSuccess(
            title: "Sucesso",
            message: "Exame atualizado com sucesso!"
        )
    }
    
    func examUpdateDidFail(error: Error) {
        print("❌ ExameDetailPresenter: Erro ao atualizar exame: \(error.localizedDescription)")
        view?.hideLoading()
        
        let errorMessage: String
        if let serviceError = error as? ExameServiceError {
            errorMessage = serviceError.localizedDescription
        } else {
            errorMessage = "Não foi possível atualizar o exame."
        }
        
        view?.showError(title: "Erro ao Atualizar", message: errorMessage)
    }
    
    func examDidDelete() {
        print("✅ ExameDetailPresenter: Exame deletado")
        view?.hideLoading()
        view?.showSuccess(
            title: "Sucesso",
            message: "Exame excluído com sucesso!"
        )
        
        // Dismiss after short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.exameDetailRouter?.dismiss()
        }
    }
    
    func examDeleteDidFail(error: Error) {
        print("❌ ExameDetailPresenter: Erro ao deletar exame: \(error.localizedDescription)")
        view?.hideLoading()
        
        let errorMessage: String
        if let serviceError = error as? ExameServiceError {
            errorMessage = serviceError.localizedDescription
        } else {
            errorMessage = "Não foi possível excluir o exame."
        }
        
        view?.showError(title: "Erro ao Excluir", message: errorMessage)
    }
    
    func fileDidDownload(fileURL: URL) {
        print("✅ ExameDetailPresenter: Arquivo baixado: \(fileURL)")
        view?.hideLoading()
        exameDetailRouter?.showFileViewer(fileURL: fileURL)
    }
    
    func fileDownloadDidFail(error: Error) {
        print("❌ ExameDetailPresenter: Erro ao baixar arquivo: \(error.localizedDescription)")
        view?.hideLoading()
        view?.showError(
            title: "Erro ao Baixar",
            message: "Não foi possível baixar o arquivo."
        )
    }
}

// MARK: - Public Configuration

extension ExameDetailPresenter {
    /// Configures the presenter with an exam
    /// - Parameter exame: The exam to display
    func configure(with exame: ExameModel) {
        self.currentExame = exame
    }
}


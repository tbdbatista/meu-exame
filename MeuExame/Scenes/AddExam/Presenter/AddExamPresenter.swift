import Foundation

/// AddExamPresenter é o Presenter da tela de cadastro de exames.
/// Segue o padrão VIPER, mediando a comunicação entre View, Interactor e Router.
final class AddExamPresenter {
    
    // MARK: - VIPER Properties (Base Protocols)
    
    weak var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    
    // MARK: - Private Helpers
    
    private var addExamView: AddExamViewProtocol? {
        return view as? AddExamViewProtocol
    }
    
    private var addExamInteractor: AddExamInteractorProtocol? {
        return interactor as? AddExamInteractorProtocol
    }
    
    private var addExamRouter: AddExamRouterProtocol? {
        return router as? AddExamRouterProtocol
    }
}

// MARK: - PresenterProtocol

extension AddExamPresenter: PresenterProtocol {
    func viewDidLoad() {
        print("📝 AddExamPresenter: View carregada")
    }
    
    func viewWillAppear() {
        print("📝 AddExamPresenter: View irá aparecer")
    }
}

// MARK: - AddExamPresenterProtocol

extension AddExamPresenter: AddExamPresenterProtocol {
    func didTapSave(nome: String?, local: String?, medico: String?, motivo: String?, data: Date, isScheduled: Bool, fileData: Data?, fileName: String?) {
        print("📝 AddExamPresenter: Tentando salvar exame")
        
        // Validate input
        let validationResult = validateInput(nome: nome, local: local, medico: medico, motivo: motivo)
        
        guard validationResult.isValid else {
            print("❌ AddExamPresenter: Validação falhou")
            showValidationErrors(validationResult.errors)
            return
        }
        
        // Clear previous errors
        addExamView?.hideFieldError(field: "nome")
        addExamView?.hideFieldError(field: "local")
        addExamView?.hideFieldError(field: "medico")
        addExamView?.hideFieldError(field: "motivo")
        
        // Create exam model
        let exame = ExameModel(
            id: UUID().uuidString,
            nome: nome!,
            localRealizado: local!,
            medicoSolicitante: medico!,
            motivoQueixa: motivo!,
            dataCadastro: data,
            urlArquivo: nil // Will be set after upload if file exists
        )
        
        print("📝 AddExamPresenter: Criando exame: \(exame.nome) (agendado: \(isScheduled))")
        view?.showLoading()
        
        addExamInteractor?.createExam(exame: exame, isScheduled: isScheduled, fileData: fileData, fileName: fileName)
    }
    
    func didTapAttachFile() {
        print("📎 AddExamPresenter: Solicitar anexo de arquivo")
        addExamRouter?.showFilePicker()
    }
    
    func didTapRemoveFile() {
        print("📎 AddExamPresenter: Remover arquivo anexado")
        addExamView?.updateFileAttachment(fileName: nil, hasFile: false)
    }
    
    func didTapCancel() {
        print("📝 AddExamPresenter: Cancelar cadastro")
        addExamRouter?.dismiss()
    }
    
    // MARK: - Validation
    
    private func validateInput(nome: String?, local: String?, medico: String?, motivo: String?) -> ExamValidationResult {
        var errors: [String: String] = [:]
        
        // Nome is required
        if let nome = nome, !nome.trimmingCharacters(in: .whitespaces).isEmpty {
            // Valid
        } else {
            errors["nome"] = "Nome do exame é obrigatório"
        }
        
        // Local is required
        if let local = local, !local.trimmingCharacters(in: .whitespaces).isEmpty {
            // Valid
        } else {
            errors["local"] = "Local é obrigatório"
        }
        
        // Médico is required
        if let medico = medico, !medico.trimmingCharacters(in: .whitespaces).isEmpty {
            // Valid
        } else {
            errors["medico"] = "Médico solicitante é obrigatório"
        }
        
        // Motivo is required
        if let motivo = motivo, !motivo.trimmingCharacters(in: .whitespaces).isEmpty {
            // Valid
        } else {
            errors["motivo"] = "Motivo/queixa é obrigatório"
        }
        
        if errors.isEmpty {
            return .valid
        } else {
            return .invalid(errors: errors)
        }
    }
    
    private func showValidationErrors(_ errors: [String: String]) {
        for (field, message) in errors {
            addExamView?.showFieldError(field: field, message: message)
        }
    }
}

// MARK: - AddExamInteractorOutputProtocol

extension AddExamPresenter: AddExamInteractorOutputProtocol {
    func examDidCreate(_ exame: ExameModel) {
        print("✅ AddExamPresenter: Exame criado com sucesso: \(exame.nome)")
        view?.hideLoading()
        view?.showSuccess(
            title: "Sucesso!",
            message: "Exame \"\(exame.nome)\" cadastrado com sucesso."
        )
        addExamView?.clearForm()
    }
    
    func examCreateDidFail(error: Error) {
        print("❌ AddExamPresenter: Erro ao criar exame: \(error.localizedDescription)")
        view?.hideLoading()
        
        let errorMessage: String
        if let serviceError = error as? ExameServiceError {
            errorMessage = serviceError.localizedDescription
        } else {
            errorMessage = "Não foi possível cadastrar o exame. Tente novamente."
        }
        
        view?.showError(
            title: "Erro ao Cadastrar",
            message: errorMessage
        )
    }
    
    func uploadProgressDidUpdate(progress: Double) {
        print("📤 AddExamPresenter: Upload progress: \(Int(progress * 100))%")
        // TODO: Update UI with progress if needed
    }
}


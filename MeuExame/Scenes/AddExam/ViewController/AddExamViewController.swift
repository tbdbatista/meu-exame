import UIKit

/// AddExamViewController é o View Controller da tela de cadastro de exames.
/// Segue o padrão VIPER, gerenciando a View e repassando eventos para o Presenter.
final class AddExamViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: PresenterProtocol?
    private let addExamView = AddExamView()
    
    // MARK: - Private Helpers
    
    private var addExamPresenter: AddExamPresenterProtocol? {
        return presenter as? AddExamPresenterProtocol
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = addExamView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Novo Exame"
        
        // Cancel button
        let cancelButton = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func setupActions() {
        addExamView.onSaveTapped = { [weak self] nome, local, medico, motivo, data, scheduledDate, fileData, fileName in
            self?.addExamPresenter?.didTapSave(
                nome: nome,
                local: local,
                medico: medico,
                motivo: motivo,
                data: data,
                scheduledDate: scheduledDate,
                fileData: fileData,
                fileName: fileName
            )
        }
        
        addExamView.onCancelTapped = { [weak self] in
            self?.addExamPresenter?.didTapCancel()
        }
        
        addExamView.onAttachFileTapped = { [weak self] in
            self?.addExamPresenter?.didTapAttachFile()
        }
        
        addExamView.onRemoveFileTapped = { [weak self] in
            self?.addExamPresenter?.didTapRemoveFile()
        }
    }
    
    // MARK: - Actions
    
    @objc private func cancelButtonTapped() {
        addExamPresenter?.didTapCancel()
    }
}

// MARK: - AddExamViewProtocol

extension AddExamViewController: AddExamViewProtocol {
    func clearForm() {
        addExamView.clearForm()
    }
    
    func showFieldError(field: String, message: String) {
        addExamView.showFieldError(field: field, message: message)
    }
    
    func hideFieldError(field: String) {
        addExamView.hideFieldError(field: field)
    }
    
    func updateFileAttachment(fileName: String?, hasFile: Bool) {
        addExamView.updateFileAttachment(fileName: fileName, hasFile: hasFile)
    }
    
    // MARK: - ViewProtocol
    
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.tag = 999
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        // Disable interactions
        view.isUserInteractionEnabled = false
        addExamView.saveButton.isEnabled = false
        addExamView.saveButton.alpha = 0.5
    }
    
    func hideLoading() {
        if let activityIndicator = view.viewWithTag(999) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        
        // Enable interactions
        view.isUserInteractionEnabled = true
        addExamView.saveButton.isEnabled = true
        addExamView.saveButton.alpha = 1.0
    }
    
    func showError(title: String, message: String) {
        hideLoading()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    func showSuccess(title: String, message: String) {
        hideLoading()
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.addExamPresenter?.didTapCancel()
        })
        present(alert, animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate

extension AddExamViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        
        // Start accessing security-scoped resource
        guard url.startAccessingSecurityScopedResource() else {
            showError(title: "Erro", message: "Não foi possível acessar o arquivo.")
            return
        }
        
        defer { url.stopAccessingSecurityScopedResource() }
        
        do {
            let data = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
            
            // Check file size (max 10MB)
            let maxSize = 10 * 1024 * 1024 // 10MB
            if data.count > maxSize {
                showError(title: "Arquivo muito grande", message: "O arquivo deve ter no máximo 10MB.")
                return
            }
            
            addExamView.setAttachedFile(data: data, fileName: fileName)
            print("📎 Arquivo anexado: \(fileName) (\(data.count) bytes)")
            
        } catch {
            showError(title: "Erro", message: "Não foi possível ler o arquivo: \(error.localizedDescription)")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("📎 Seleção de arquivo cancelada")
    }
}


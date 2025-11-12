import UIKit
import UniformTypeIdentifiers

/// ExameDetailViewController é o View Controller da tela de detalhes do exame.
/// Segue o padrão VIPER, gerenciando a View e repassando eventos para o Presenter.
final class ExameDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: PresenterProtocol?
    private let exameDetailView = ExameDetailView()
    
    // MARK: - Private Helpers
    
    private var exameDetailPresenter: ExameDetailPresenterProtocol? {
        return presenter as? ExameDetailPresenterProtocol
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = exameDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        presenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Detalhes do Exame"
        
        // Edit button
        let editButton = UIBarButtonItem(
            barButtonSystemItem: .edit,
            target: self,
            action: #selector(editButtonTapped)
        )
        
        // Delete button
        let deleteButton = UIBarButtonItem(
            barButtonSystemItem: .trash,
            target: self,
            action: #selector(deleteButtonTapped)
        )
        
        // Share button
        let shareButton = UIBarButtonItem(
            barButtonSystemItem: .action,
            target: self,
            action: #selector(shareButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [deleteButton, editButton, shareButton]
    }
    
    private func setupActions() {
        exameDetailView.onSaveTapped = { [weak self] nome, local, medico, motivo, data, fileData, fileName, hasFileChanged in
            self?.exameDetailPresenter?.didTapSave(
                nome: nome,
                local: local,
                medico: medico,
                motivo: motivo,
                data: data,
                fileData: fileData,
                fileName: fileName,
                hasFileChanged: hasFileChanged
            )
        }
        
        exameDetailView.onCancelTapped = { [weak self] in
            self?.exameDetailPresenter?.didTapCancel()
        }
        
        exameDetailView.onViewFileTapped = { [weak self] in
            self?.exameDetailPresenter?.didTapViewFile()
        }
        
        exameDetailView.onAttachFileTapped = { [weak self] in
            self?.presentDocumentPicker()
        }
        
        exameDetailView.onRemoveFileTapped = { [weak self] in
            print("🗑️ File removed from ExameDetailView")
        }
    }
    
    private func presentDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [UTType.pdf, UTType.image, UTType.text])
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true)
    }
    
    // MARK: - Actions
    
    @objc private func editButtonTapped() {
        exameDetailPresenter?.didTapEdit()
    }
    
    @objc private func deleteButtonTapped() {
        exameDetailPresenter?.didTapDelete()
    }
    
    @objc private func shareButtonTapped() {
        exameDetailPresenter?.didTapShare()
    }
}

// MARK: - ExameDetailViewProtocol

extension ExameDetailViewController: ExameDetailViewProtocol {
    func updateExamInfo(_ exame: ExameModel) {
        exameDetailView.updateExamInfo(exame)
    }
    
    func showEditMode() {
        exameDetailView.showEditMode()
        
        // Update navigation bar
        navigationItem.rightBarButtonItems = []
        title = "Editar Exame"
    }
    
    func showViewMode() {
        exameDetailView.showViewMode()
        
        // Restore navigation bar
        setupNavigationBar()
        title = "Detalhes do Exame"
    }
    
    func updateFileAttachment(hasFile: Bool, fileName: String?) {
        exameDetailView.updateFileAttachment(hasFile: hasFile, fileName: fileName)
    }
    
    // MARK: - ViewProtocol
    
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.tag = 999
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        if let activityIndicator = view.viewWithTag(999) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
        
        view.isUserInteractionEnabled = true
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
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UIDocumentPickerDelegate

extension ExameDetailViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first, url.startAccessingSecurityScopedResource() else {
            print("❌ Failed to access security scoped resource")
            return
        }
        
        defer {
            url.stopAccessingSecurityScopedResource()
        }
        
        do {
            let fileData = try Data(contentsOf: url)
            let fileName = url.lastPathComponent
            
            print("📎 File selected: \(fileName) (\(fileData.count) bytes)")
            
            exameDetailView.setAttachedFile(data: fileData, fileName: fileName)
        } catch {
            print("❌ Error reading file: \(error.localizedDescription)")
            showError(title: "Erro", message: "Não foi possível ler o arquivo selecionado.")
        }
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("📎 Document picker cancelled")
    }
}


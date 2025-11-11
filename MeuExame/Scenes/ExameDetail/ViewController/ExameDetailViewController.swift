import UIKit

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
        exameDetailView.onSaveTapped = { [weak self] nome, local, medico, motivo, data in
            self?.exameDetailPresenter?.didTapSave(
                nome: nome,
                local: local,
                medico: medico,
                motivo: motivo,
                data: data
            )
        }
        
        exameDetailView.onCancelTapped = { [weak self] in
            self?.exameDetailPresenter?.didTapCancel()
        }
        
        exameDetailView.onViewFileTapped = { [weak self] in
            self?.exameDetailPresenter?.didTapViewFile()
        }
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


import UIKit
import Photos

/// ProfileViewController manages the Profile screen
final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    var presenter: PresenterProtocol?
    private var profilePresenter: ProfilePresenterProtocol? {
        return presenter as? ProfilePresenterProtocol
    }
    
    private let profileView = ProfileView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = profileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupActions()
        profilePresenter?.viewDidLoad()
    }
    
    // MARK: - Setup
    
    private func setupNavigationBar() {
        title = "Perfil"
        
        // Save button
        let saveButton = UIBarButtonItem(
            title: "Salvar",
            style: .done,
            target: self,
            action: #selector(saveButtonTapped)
        )
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupActions() {
        profileView.onEditPhotoTapped = { [weak self] in
            self?.presentPhotoPicker()
        }
        
        profileView.onChangePasswordTapped = { [weak self] in
            self?.profilePresenter?.didTapChangePassword()
        }
        
        profileView.onLogoutTapped = { [weak self] in
            self?.showLogoutConfirmation()
        }
        
        profileView.onDeleteAccountTapped = { [weak self] in
            self?.showDeleteAccountConfirmation()
        }
    }
    
    // MARK: - Actions
    
    @objc private func saveButtonTapped() {
        let data = profileView.getUserInputData()
        profilePresenter?.didTapSave(
            nome: data.nome,
            telefone: data.telefone,
            dataNascimento: data.dataNascimento
        )
    }
    
    private func presentPhotoPicker() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        let alert = UIAlertController(title: "Alterar Foto", message: nil, preferredStyle: .actionSheet)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(UIAlertAction(title: "Câmera", style: .default) { _ in
                picker.sourceType = .camera
                self.present(picker, animated: true)
            })
        }
        
        alert.addAction(UIAlertAction(title: "Galeria", style: .default) { _ in
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true)
        })
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        
        present(alert, animated: true)
    }
    
    private func showLogoutConfirmation() {
        let alert = UIAlertController(
            title: "Sair",
            message: "Deseja realmente sair da sua conta?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sair", style: .destructive) { [weak self] _ in
            self?.profilePresenter?.didTapLogout()
        })
        
        present(alert, animated: true)
    }
    
    private func showDeleteAccountConfirmation() {
        let alert = UIAlertController(
            title: "⚠️ Excluir Conta",
            message: "Esta ação é IRREVERSÍVEL. Todos os seus dados serão perdidos permanentemente. Deseja continuar?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Excluir", style: .destructive) { [weak self] _ in
            self?.profilePresenter?.didConfirmDeleteAccount()
        })
        
        present(alert, animated: true)
    }
}

// MARK: - ProfileViewProtocol

extension ProfileViewController: ProfileViewProtocol {
    func updateUserInfo(_ user: UserModel) {
        profileView.updateUserInfo(user)
    }
    
    func showPhotoPicker() {
        presentPhotoPicker()
    }
    
    func showChangePasswordScreen() {
        let alert = UIAlertController(title: "Trocar Senha", message: "Digite sua senha atual e a nova senha", preferredStyle: .alert)
        
        alert.addTextField { textField in
            textField.placeholder = "Senha atual"
            textField.isSecureTextEntry = true
        }
        
        alert.addTextField { textField in
            textField.placeholder = "Nova senha"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        alert.addAction(UIAlertAction(title: "Alterar", style: .default) { [weak self] _ in
            let currentPassword = alert.textFields?[0].text ?? ""
            let newPassword = alert.textFields?[1].text ?? ""
            self?.profilePresenter?.didConfirmPasswordChange(currentPassword: currentPassword, newPassword: newPassword)
        })
        
        present(alert, animated: true)
    }
    
    // MARK: - ViewProtocol
    
    func showLoading() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.tag = 999
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
        view.isUserInteractionEnabled = false
    }
    
    func hideLoading() {
        view.viewWithTag(999)?.removeFromSuperview()
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

// MARK: - UIImagePickerControllerDelegate

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
            profileView.updateProfilePhoto(image: image)
            
            if let imageData = image.jpegData(compressionQuality: 0.7) {
                profilePresenter?.didSelectPhoto(imageData: imageData)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}


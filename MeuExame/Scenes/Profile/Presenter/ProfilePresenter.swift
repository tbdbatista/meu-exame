import Foundation

/// ProfilePresenter handles the presentation logic for the Profile scene
final class ProfilePresenter {
    
    // MARK: - VIPER Properties
    
    var view: ViewProtocol?
    var interactor: InteractorProtocol?
    var router: RouterProtocol?
    
    // MARK: - Private Properties
    
    private var profileView: ProfileViewProtocol? {
        return view as? ProfileViewProtocol
    }
    
    private var profileInteractor: ProfileInteractorProtocol? {
        return interactor as? ProfileInteractorProtocol
    }
    
    private var profileRouter: ProfileRouterProtocol? {
        return router as? ProfileRouterProtocol
    }
    
    private var currentUser: UserModel?
}

// MARK: - PresenterProtocol

extension ProfilePresenter: PresenterProtocol {
    // Base protocol conformance
}

// MARK: - ProfilePresenterProtocol

extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        print("🔵 ProfilePresenter: viewDidLoad")
        view?.showLoading()
        profileInteractor?.fetchCurrentUser()
    }
    
    func didTapEditPhoto() {
        print("📸 ProfilePresenter: didTapEditPhoto")
        profileView?.showPhotoPicker()
    }
    
    func didSelectPhoto(imageData: Data) {
        print("📸 ProfilePresenter: didSelectPhoto (\(imageData.count) bytes)")
        guard let user = currentUser else { return }
        
        view?.showLoading()
        profileInteractor?.uploadProfilePhoto(imageData: imageData, userId: user.uid)
    }
    
    func didTapSave(nome: String?, telefone: String?, dataNascimento: Date?) {
        print("💾 ProfilePresenter: didTapSave")
        
        guard let user = currentUser else {
            view?.showError(title: "Erro", message: "Usuário não encontrado")
            return
        }
        
        // Create updated user
        let updatedUser = UserModel(
            uid: user.uid,
            nome: nome,
            email: user.email,
            telefone: telefone,
            dataNascimento: dataNascimento,
            photoURL: user.photoURL,
            dataCriacao: user.dataCriacao,
            dataAtualizacao: Date()
        )
        
        view?.showLoading()
        profileInteractor?.updateUser(updatedUser)
    }
    
    func didTapChangePassword() {
        print("🔑 ProfilePresenter: didTapChangePassword")
        profileView?.showChangePasswordScreen()
    }
    
    func didConfirmPasswordChange(currentPassword: String, newPassword: String) {
        print("🔑 ProfilePresenter: didConfirmPasswordChange")
        
        // Validate
        guard !currentPassword.isEmpty else {
            view?.showError(title: "Erro", message: "Digite sua senha atual")
            return
        }
        
        guard newPassword.count >= 6 else {
            view?.showError(title: "Erro", message: "A nova senha deve ter no mínimo 6 caracteres")
            return
        }
        
        view?.showLoading()
        profileInteractor?.changePassword(currentPassword: currentPassword, newPassword: newPassword)
    }
    
    func didTapLogout() {
        print("🚪 ProfilePresenter: didTapLogout")
        profileInteractor?.logout()
    }
    
    func didTapDeleteAccount() {
        print("🗑️ ProfilePresenter: didTapDeleteAccount")
        // View should show confirmation first
    }
    
    func didConfirmDeleteAccount() {
        print("🗑️ ProfilePresenter: didConfirmDeleteAccount")
        view?.showLoading()
        profileInteractor?.deleteAccount()
    }
}

// MARK: - ProfileInteractorOutputProtocol

extension ProfilePresenter: ProfileInteractorOutputProtocol {
    func userDidLoad(_ user: UserModel) {
        print("✅ ProfilePresenter: userDidLoad - \(user.displayName)")
        currentUser = user
        view?.hideLoading()
        profileView?.updateUserInfo(user)
    }
    
    func userLoadDidFail(error: Error) {
        print("❌ ProfilePresenter: userLoadDidFail - \(error.localizedDescription)")
        view?.hideLoading()
        view?.showError(title: "Erro", message: "Não foi possível carregar o perfil. \(error.localizedDescription)")
    }
    
    func userDidUpdate(_ user: UserModel) {
        print("✅ ProfilePresenter: userDidUpdate")
        currentUser = user
        view?.hideLoading()
        view?.showSuccess(title: "Sucesso", message: "Perfil atualizado com sucesso!")
    }
    
    func userUpdateDidFail(error: Error) {
        print("❌ ProfilePresenter: userUpdateDidFail - \(error.localizedDescription)")
        view?.hideLoading()
        view?.showError(title: "Erro", message: "Não foi possível atualizar o perfil. \(error.localizedDescription)")
    }
    
    func photoDidUpload(photoURL: String) {
        print("✅ ProfilePresenter: photoDidUpload - \(photoURL)")
        
        guard var user = currentUser else { return }
        
        // Update local user with new photo URL
        user = UserModel(
            uid: user.uid,
            nome: user.nome,
            email: user.email,
            telefone: user.telefone,
            dataNascimento: user.dataNascimento,
            photoURL: photoURL,
            dataCriacao: user.dataCriacao,
            dataAtualizacao: Date()
        )
        
        // Save to Firestore
        profileInteractor?.updateUser(user)
    }
    
    func photoUploadDidFail(error: Error) {
        print("❌ ProfilePresenter: photoUploadDidFail - \(error.localizedDescription)")
        view?.hideLoading()
        view?.showError(title: "Erro", message: "Não foi possível fazer upload da foto. \(error.localizedDescription)")
    }
    
    func passwordDidChange() {
        print("✅ ProfilePresenter: passwordDidChange")
        view?.hideLoading()
        view?.showSuccess(title: "Sucesso", message: "Senha alterada com sucesso!")
    }
    
    func passwordChangeDidFail(error: Error) {
        print("❌ ProfilePresenter: passwordChangeDidFail - \(error.localizedDescription)")
        view?.hideLoading()
        
        let message: String
        if error.localizedDescription.contains("requires-recent-login") {
            message = "Por segurança, faça login novamente antes de alterar a senha."
        } else if error.localizedDescription.contains("wrong-password") {
            message = "Senha atual incorreta."
        } else {
            message = "Não foi possível alterar a senha. \(error.localizedDescription)"
        }
        
        view?.showError(title: "Erro", message: message)
    }
    
    func logoutDidSucceed() {
        print("✅ ProfilePresenter: logoutDidSucceed")
        profileRouter?.showLoginScreen()
    }
    
    func accountDeletionDidSucceed() {
        print("✅ ProfilePresenter: accountDeletionDidSucceed")
        view?.hideLoading()
        profileRouter?.showLoginScreen()
    }
    
    func accountDeletionDidFail(error: Error) {
        print("❌ ProfilePresenter: accountDeletionDidFail - \(error.localizedDescription)")
        view?.hideLoading()
        
        let message: String
        if error.localizedDescription.contains("requires-recent-login") {
            message = "Por segurança, faça login novamente antes de excluir a conta."
        } else {
            message = "Não foi possível excluir a conta. \(error.localizedDescription)"
        }
        
        view?.showError(title: "Erro", message: message)
    }
}


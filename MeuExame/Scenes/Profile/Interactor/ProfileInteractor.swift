import Foundation
import FirebaseAuth

/// ProfileInteractor handles the business logic for the Profile scene
final class ProfileInteractor {
    
    // MARK: - VIPER Properties
    
    var presenter: PresenterProtocol?
    weak var output: ProfileInteractorOutputProtocol?
    
    // MARK: - Services
    
    private let userService: UserServiceProtocol
    private let storageService: StorageServiceProtocol
    
    // MARK: - Initialization
    
    init(userService: UserServiceProtocol, storageService: StorageServiceProtocol) {
        self.userService = userService
        self.storageService = storageService
    }
}

// MARK: - InteractorProtocol

extension ProfileInteractor: InteractorProtocol {
    // Base protocol conformance
}

// MARK: - ProfileInteractorProtocol

extension ProfileInteractor: ProfileInteractorProtocol {
    func fetchCurrentUser() {
        print("🔍 ProfileInteractor: fetchCurrentUser")
        
        userService.fetchCurrentUser { [weak self] result in
            switch result {
            case .success(let user):
                print("✅ ProfileInteractor: User fetched - \(user.email)")
                self?.output?.userDidLoad(user)
                
            case .failure(let error):
                print("❌ ProfileInteractor: Failed to fetch user - \(error.localizedDescription)")
                self?.output?.userLoadDidFail(error: error)
            }
        }
    }
    
    func updateUser(_ user: UserModel) {
        print("💾 ProfileInteractor: updateUser - \(user.email)")
        
        userService.saveUser(user) { [weak self] result in
            switch result {
            case .success:
                print("✅ ProfileInteractor: User updated successfully")
                self?.output?.userDidUpdate(user)
                
            case .failure(let error):
                print("❌ ProfileInteractor: Failed to update user - \(error.localizedDescription)")
                self?.output?.userUpdateDidFail(error: error)
            }
        }
    }
    
    func uploadProfilePhoto(imageData: Data, userId: String) {
        print("📤 ProfileInteractor: uploadProfilePhoto - \(imageData.count) bytes")
        
        let storagePath = "profile_photos/\(userId)/profile.jpg"
        
        storageService.upload(data: imageData, to: storagePath) { [weak self] result in
            switch result {
            case .success(let downloadURL):
                print("✅ ProfileInteractor: Photo uploaded - \(downloadURL)")
                self?.output?.photoDidUpload(photoURL: downloadURL)
                
            case .failure(let error):
                print("❌ ProfileInteractor: Photo upload failed - \(error.localizedDescription)")
                self?.output?.photoUploadDidFail(error: error)
            }
        }
    }
    
    func changePassword(currentPassword: String, newPassword: String) {
        print("🔑 ProfileInteractor: changePassword")
        
        // Re-authenticate user first
        guard let user = Auth.auth().currentUser, let email = user.email else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado"])
            output?.passwordChangeDidFail(error: error)
            return
        }
        
        let credential = EmailAuthProvider.credential(withEmail: email, password: currentPassword)
        
        user.reauthenticate(with: credential) { [weak self] _, error in
            if let error = error {
                print("❌ ProfileInteractor: Re-authentication failed - \(error.localizedDescription)")
                self?.output?.passwordChangeDidFail(error: error)
                return
            }
            
            // Re-authentication successful, now change password
            self?.userService.changePassword(newPassword: newPassword) { result in
                switch result {
                case .success:
                    print("✅ ProfileInteractor: Password changed successfully")
                    self?.output?.passwordDidChange()
                    
                case .failure(let error):
                    print("❌ ProfileInteractor: Password change failed - \(error.localizedDescription)")
                    self?.output?.passwordChangeDidFail(error: error)
                }
            }
        }
    }
    
    func logout() {
        print("🚪 ProfileInteractor: logout")
        
        do {
            try Auth.auth().signOut()
            print("✅ ProfileInteractor: Logout successful")
            output?.logoutDidSucceed()
        } catch {
            print("❌ ProfileInteractor: Logout failed - \(error.localizedDescription)")
            // Even if logout fails, still navigate (safety measure)
            output?.logoutDidSucceed()
        }
    }
    
    func deleteAccount() {
        print("🗑️ ProfileInteractor: deleteAccount")
        
        userService.deleteAccount { [weak self] result in
            switch result {
            case .success:
                print("✅ ProfileInteractor: Account deleted successfully")
                self?.output?.accountDeletionDidSucceed()
                
            case .failure(let error):
                print("❌ ProfileInteractor: Account deletion failed - \(error.localizedDescription)")
                self?.output?.accountDeletionDidFail(error: error)
            }
        }
    }
}


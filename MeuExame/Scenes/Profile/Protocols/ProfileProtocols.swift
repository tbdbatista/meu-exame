import Foundation
import UIKit

// MARK: - ProfileViewProtocol

/// Protocol for the Profile View.
/// Defines methods that the ProfilePresenter can call on the View.
protocol ProfileViewProtocol: ViewProtocol {
    /// Updates the user profile information displayed
    /// - Parameter user: The user model to display
    func updateUserInfo(_ user: UserModel)
    
    /// Shows the photo picker
    func showPhotoPicker()
    
    /// Shows the change password screen
    func showChangePasswordScreen()
}

// MARK: - ProfilePresenterProtocol

/// Protocol for the Profile Presenter.
/// Extends `PresenterProtocol` with specific methods for handling Profile UI events.
protocol ProfilePresenterProtocol: PresenterProtocol {
    /// Called when the view loads
    func viewDidLoad()
    
    /// Called when the user taps the edit photo button
    func didTapEditPhoto()
    
    /// Called when the user selects a photo
    /// - Parameter imageData: The selected image data
    func didSelectPhoto(imageData: Data)
    
    /// Called when the user taps save
    /// - Parameters:
    ///   - nome: Updated name
    ///   - telefone: Updated phone
    ///   - dataNascimento: Updated birth date
    func didTapSave(nome: String?, telefone: String?, dataNascimento: Date?)
    
    /// Called when the user taps change password
    func didTapChangePassword()
    
    /// Called when the user confirms password change
    /// - Parameters:
    ///   - currentPassword: Current password for re-authentication
    ///   - newPassword: New password
    func didConfirmPasswordChange(currentPassword: String, newPassword: String)
    
    /// Called when the user taps logout
    func didTapLogout()
    
    /// Called when the user taps delete account
    func didTapDeleteAccount()
    
    /// Called when the user confirms account deletion
    func didConfirmDeleteAccount()
}

// MARK: - ProfileInteractorProtocol

/// Protocol for the Profile Interactor.
/// Extends `InteractorProtocol` with specific business logic methods.
protocol ProfileInteractorProtocol: InteractorProtocol {
    /// Fetches the current user profile
    func fetchCurrentUser()
    
    /// Updates user profile
    /// - Parameter user: Updated user model
    func updateUser(_ user: UserModel)
    
    /// Uploads profile photo
    /// - Parameters:
    ///   - imageData: Image data to upload
    ///   - userId: User ID
    func uploadProfilePhoto(imageData: Data, userId: String)
    
    /// Changes user password
    /// - Parameters:
    ///   - currentPassword: Current password for re-authentication
    ///   - newPassword: New password
    func changePassword(currentPassword: String, newPassword: String)
    
    /// Logs out the current user
    func logout()
    
    /// Deletes the user account
    func deleteAccount()
}

// MARK: - ProfileInteractorOutputProtocol

/// Protocol for Profile Interactor output (callbacks to Presenter).
protocol ProfileInteractorOutputProtocol: AnyObject {
    /// Called when user is successfully fetched
    /// - Parameter user: The user model
    func userDidLoad(_ user: UserModel)
    
    /// Called when user fetch fails
    /// - Parameter error: The error
    func userLoadDidFail(error: Error)
    
    /// Called when user is successfully updated
    /// - Parameter user: The updated user model
    func userDidUpdate(_ user: UserModel)
    
    /// Called when user update fails
    /// - Parameter error: The error
    func userUpdateDidFail(error: Error)
    
    /// Called when photo is successfully uploaded
    /// - Parameter photoURL: The uploaded photo URL
    func photoDidUpload(photoURL: String)
    
    /// Called when photo upload fails
    /// - Parameter error: The error
    func photoUploadDidFail(error: Error)
    
    /// Called when password is successfully changed
    func passwordDidChange()
    
    /// Called when password change fails
    /// - Parameter error: The error
    func passwordChangeDidFail(error: Error)
    
    /// Called when logout is successful
    func logoutDidSucceed()
    
    /// Called when account deletion is successful
    func accountDeletionDidSucceed()
    
    /// Called when account deletion fails
    /// - Parameter error: The error
    func accountDeletionDidFail(error: Error)
}

// MARK: - ProfileRouterProtocol

/// Protocol for the Profile Router.
/// Handles navigation from the Profile scene.
protocol ProfileRouterProtocol: RouterProtocol {
    /// Navigates to the change password screen
    func showChangePasswordScreen()
    
    /// Dismisses the profile screen
    func dismiss()
    
    /// Navigates to the login screen (after logout/deletion)
    func showLoginScreen()
}


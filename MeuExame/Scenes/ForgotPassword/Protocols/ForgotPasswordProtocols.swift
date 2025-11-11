import UIKit

// MARK: - ForgotPassword Protocols

/// Protocol for the ForgotPassword View.
/// Extends `ViewProtocol` with specific methods for the ForgotPassword screen.
protocol ForgotPasswordViewProtocol: ViewProtocol {
    /// Clears the email field
    func clearEmail()
    
    /// Shows error for email field
    /// - Parameter message: Error message to display
    func showEmailError(_ message: String)
    
    /// Hides error for email field
    func hideEmailError()
}

/// Protocol for the ForgotPassword Presenter.
/// Extends `PresenterProtocol` with specific methods for handling ForgotPassword UI events.
protocol ForgotPasswordPresenterProtocol: PresenterProtocol {
    /// Called when the user taps the send reset link button
    /// - Parameter email: The email address entered
    func didTapSendResetLink(email: String?)
    
    /// Called when the user taps back/cancel
    func didTapBack()
}

/// Protocol for the ForgotPassword Interactor.
/// Extends `InteractorProtocol` with specific methods for ForgotPassword business logic.
protocol ForgotPasswordInteractorProtocol: InteractorProtocol {
    /// Sends password reset email
    /// - Parameter email: The email address to send reset link to
    func sendPasswordResetEmail(email: String)
}

/// Protocol for the ForgotPassword Interactor's output.
/// Used by the Interactor to communicate results back to the Presenter.
protocol ForgotPasswordInteractorOutputProtocol: AnyObject {
    /// Called when password reset email is successfully sent
    func passwordResetEmailDidSend()
    
    /// Called when password reset email send fails
    /// - Parameter error: The error that occurred
    func passwordResetEmailDidFail(error: Error)
}

/// Protocol for the ForgotPassword Router.
/// Extends `RouterProtocol` with specific navigation methods for the ForgotPassword module.
protocol ForgotPasswordRouterProtocol: RouterProtocol {
    /// Dismisses the forgot password screen
    func dismiss()
}


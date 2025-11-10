import UIKit

// MARK: - Register Protocols

/// Protocol for the Register View.
/// Extends `ViewProtocol` with specific methods for the Register screen.
protocol RegisterViewProtocol: ViewProtocol {
    /// Returns the credentials entered by the user
    func getCredentials() -> (email: String, password: String, confirmPassword: String)
    
    /// Validates all input fields
    /// - Returns: Tuple with validation result and optional error message
    func validateFields() -> (isValid: Bool, errorMessage: String?)
    
    /// Clears all input fields
    func clearFields()
}

/// Protocol for the Register Presenter.
/// Extends `PresenterProtocol` with specific methods for handling Register UI events.
protocol RegisterPresenterProtocol: PresenterProtocol {
    /// Called when the user taps the Register button
    /// - Parameters:
    ///   - email: The email entered
    ///   - password: The password entered
    ///   - confirmPassword: The password confirmation entered
    func didTapRegister(email: String, password: String, confirmPassword: String)
    
    /// Called when the user taps the Back to Login button
    func didTapBackToLogin()
    
    /// Called when the user taps the Terms of Service link
    func didTapTermsOfService()
}

/// Protocol for the Register Interactor.
/// Extends `InteractorProtocol` with specific methods for Register business logic.
protocol RegisterInteractorProtocol: InteractorProtocol {
    /// Performs the registration process
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    func performRegister(email: String, password: String)
}

/// Protocol for the Register Interactor's output.
/// Used by the Interactor to communicate results back to the Presenter.
protocol RegisterInteractorOutputProtocol: AnyObject {
    /// Called when registration succeeds
    /// - Parameter userId: The newly created user's ID
    func registerDidSucceed(userId: String)
    
    /// Called when registration fails
    /// - Parameter error: The error that occurred
    func registerDidFail(error: Error)
}

/// Protocol for the Register Router.
/// Extends `RouterProtocol` with specific navigation methods for the Register module.
protocol RegisterRouterProtocol: RouterProtocol {
    /// Navigates back to the Login screen
    func navigateBackToLogin()
    
    /// Navigates to the Terms of Service screen
    func navigateToTermsOfService()
    
    /// Navigates to the Main screen after successful registration
    func navigateToMainScreen()
}


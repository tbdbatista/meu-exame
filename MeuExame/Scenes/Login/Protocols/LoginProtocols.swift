import UIKit

// MARK: - Login Module Protocols

/// Protocol defining the Login View responsibilities
protocol LoginViewProtocol: ViewProtocol {
    /// Gets the user credentials from input fields
    func getCredentials() -> (email: String, password: String)
    
    /// Validates the input fields
    func validateFields() -> (isValid: Bool, errorMessage: String?)
    
    /// Clears all input fields
    func clearFields()
}

/// Protocol defining the Login Presenter responsibilities
protocol LoginPresenterProtocol: PresenterProtocol {
    /// Called when user taps the login button
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    func didTapLogin(email: String, password: String)
    
    /// Called when user taps the register button
    func didTapRegister()
    
    /// Called when user taps the forgot password button
    func didTapForgotPassword()
}

/// Protocol defining the Login Interactor responsibilities
protocol LoginInteractorProtocol: InteractorProtocol {
    /// Performs login with the authentication service
    /// - Parameters:
    ///   - email: User's email
    ///   - password: User's password
    func performLogin(email: String, password: String)
}

/// Protocol for the Login Interactor to communicate back to the Presenter
protocol LoginInteractorOutputProtocol: AnyObject {
    /// Called when login succeeds
    /// - Parameter userId: The authenticated user's ID
    func loginDidSucceed(userId: String)
    
    /// Called when login fails
    /// - Parameter error: The error that occurred
    func loginDidFail(error: Error)
}

/// Protocol defining the Login Router responsibilities
protocol LoginRouterProtocol: RouterProtocol {
    /// Navigates to the Register screen
    func navigateToRegister()
    
    /// Navigates to the Forgot Password screen
    func navigateToForgotPassword()
    
    /// Navigates to the main screen (Exames List) after successful login
    func navigateToMainScreen()
}


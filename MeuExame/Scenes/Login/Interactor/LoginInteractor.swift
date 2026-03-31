import Foundation

/// LoginInteractor handles the business logic for the Login screen.
/// It communicates with services (like AuthService) and returns results to the Presenter.
final class LoginInteractor {
    
    // MARK: - VIPER Properties
    
    /// Reference to presenter (required by InteractorProtocol)
    weak var presenter: PresenterProtocol?
    
    /// Specific reference to LoginInteractorOutputProtocol for callbacks
    weak var output: LoginInteractorOutputProtocol?
    
    // MARK: - Dependencies
    
    private let authService: AuthServiceProtocol
    
    // MARK: - Initializer
    
    /// Initializes the LoginInteractor with dependencies.
    /// - Parameters:
    ///   - authService: The authentication service to use (defaults to FirebaseManager).
    ///   - presenter: Optional presenter reference for protocol conformance.
    ///   - output: Optional output callback reference.
    init(
        authService: AuthServiceProtocol = FirebaseManager.shared,
        presenter: PresenterProtocol? = nil,
        output: LoginInteractorOutputProtocol? = nil
    ) {
        self.authService = authService
        self.presenter = presenter
        self.output = output
        print("🔧 LoginInteractor: Initialized with auth service")
    }
}

// MARK: - LoginInteractorProtocol

extension LoginInteractor: LoginInteractorProtocol {
    func performLogin(email: String, password: String) {
        print("🔄 LoginInteractor: Performing login for email: \(email)")
        
        // Call the authentication service
        authService.signIn(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userId):
                print("✅ LoginInteractor: Login successful - User ID: \(userId)")
                // Notify presenter of success
                self.output?.loginDidSucceed(userId: userId)
                
            case .failure(let error):
                print("❌ LoginInteractor: Login failed - Error: \(error.localizedDescription)")
                // Notify presenter of failure
                self.output?.loginDidFail(error: error)
            }
        }
    }
}


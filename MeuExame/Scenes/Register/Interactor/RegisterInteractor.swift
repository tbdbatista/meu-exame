import Foundation

/// RegisterInteractor handles the business logic for the Register screen.
/// It communicates with services (like AuthService) and returns results to the Presenter.
final class RegisterInteractor {
    
    // MARK: - VIPER Properties
    
    /// Reference to presenter (required by InteractorProtocol)
    weak var presenter: PresenterProtocol?
    
    /// Specific reference to RegisterInteractorOutputProtocol for callbacks
    weak var output: RegisterInteractorOutputProtocol?
    
    // MARK: - Dependencies
    
    private let authService: AuthServiceProtocol
    
    // MARK: - Initializer
    
    /// Initializes the RegisterInteractor with an authentication service
    /// - Parameter authService: The authentication service to use (defaults to FirebaseManager)
    init(authService: AuthServiceProtocol = FirebaseManager.shared) {
        self.authService = authService
        print("🔧 RegisterInteractor: Initialized with auth service")
    }
}

// MARK: - RegisterInteractorProtocol

extension RegisterInteractor: RegisterInteractorProtocol {
    func performRegister(email: String, password: String) {
        print("🔄 RegisterInteractor: Performing registration for email: \(email)")
        
        // Call the authentication service
        authService.signUp(email: email, password: password) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let userId):
                print("✅ RegisterInteractor: Registration successful - User ID: \(userId)")
                // Notify presenter of success
                self.output?.registerDidSucceed(userId: userId)
                
            case .failure(let error):
                print("❌ RegisterInteractor: Registration failed - Error: \(error.localizedDescription)")
                // Notify presenter of failure
                self.output?.registerDidFail(error: error)
            }
        }
    }
}


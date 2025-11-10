import Foundation
import FirebaseAuth

/// HomeInteractor handles the business logic for the Home screen.
/// It communicates with services and returns results to the Presenter.
final class HomeInteractor {
    
    // MARK: - VIPER Properties
    
    /// Reference to presenter (required by InteractorProtocol)
    weak var presenter: PresenterProtocol?
    
    /// Specific reference to HomeInteractorOutputProtocol for callbacks
    weak var output: HomeInteractorOutputProtocol?
    
    // MARK: - Dependencies
    
    private let authService: AuthServiceProtocol
    // TODO: Add FirestoreService for exam data
    
    // MARK: - Initializer
    
    init(authService: AuthServiceProtocol = FirebaseManager.shared) {
        self.authService = authService
        print("🔧 HomeInteractor: Initialized")
    }
}

// MARK: - HomeInteractorProtocol

extension HomeInteractor: HomeInteractorProtocol {
    func fetchExamSummary() {
        print("🔄 HomeInteractor: Fetching exam summary")
        
        // TODO: Implement actual Firestore fetch
        // For now, use mock data
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            // Check if user has exams (mock)
            let summary = ExamSummary.empty // or .mock for testing
            self?.output?.examSummaryDidLoad(summary)
        }
    }
    
    func fetchUserProfile() {
        print("🔄 HomeInteractor: Fetching user profile")
        
        // Get current user from Firebase Auth
        guard let currentUserId = authService.currentUserId else {
            let error = NSError(domain: "HomeInteractor", code: 1, userInfo: [
                NSLocalizedDescriptionKey: "Usuário não autenticado"
            ])
            output?.userProfileDidFail(error: error)
            return
        }
        
        // Get user email from Firebase Auth
        if let user = Auth.auth().currentUser {
            let profile = UserProfile(
                userId: currentUserId,
                name: user.displayName,
                email: user.email ?? "usuário@exemplo.com",
                photoURL: user.photoURL?.absoluteString,
                memberSince: user.metadata.creationDate ?? Date()
            )
            output?.userProfileDidLoad(profile)
        } else {
            // Fallback to mock data
            let profile = UserProfile.mock(userId: currentUserId)
            output?.userProfileDidLoad(profile)
        }
    }
}


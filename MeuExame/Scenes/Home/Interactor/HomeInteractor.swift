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
    private let exameService: ExamesServiceProtocol
    private let userService: UserServiceProtocol
    
    // MARK: - Initializer
    
    init(
        authService: AuthServiceProtocol = FirebaseManager.shared,
        exameService: ExamesServiceProtocol,
        userService: UserServiceProtocol
    ) {
        self.authService = authService
        self.exameService = exameService
        self.userService = userService
        print("🔧 HomeInteractor: Initialized")
    }
}

// MARK: - HomeInteractorProtocol

extension HomeInteractor: HomeInteractorProtocol {
    func fetchExamSummary() {
        print("🔄 HomeInteractor: Fetching exam summary")
        
        // Fetch exams from Firestore
        exameService.fetch { [weak self] result in
            switch result {
            case .success(let exames):
                print("✅ HomeInteractor: Fetched \(exames.count) exams")
                
                // Calculate summary statistics
                let summary = self?.calculateSummary(from: exames) ?? ExamSummary.empty
                self?.output?.examSummaryDidLoad(summary)
                
            case .failure(let error):
                print("❌ HomeInteractor: Failed to fetch exams - \(error.localizedDescription)")
                
                // If error, show empty summary (user might have no exams)
                // Only report error if it's not a "no exams" situation
                if case ExameServiceError.notFound = error {
                    // No exams found - this is valid, show empty state
                    self?.output?.examSummaryDidLoad(ExamSummary.empty)
                } else {
                    // Real error
                    self?.output?.examSummaryDidFail(error: error)
                }
            }
        }
    }
    
    // MARK: - Private Helpers
    
    /// Calculates exam summary statistics from a list of exams
    private func calculateSummary(from exames: [ExameModel]) -> ExamSummary {
        let totalExams = exames.count
        
        // Calculate recent exams (last 30 days)
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
        let recentExams = exames.filter { $0.dataCadastro >= thirtyDaysAgo }
        
        // Calculate "pending" exams (for now, just count exams without files)
        let pendingExams = exames.filter { !$0.temArquivo }
        
        // Get last exam date
        let lastExamDate = exames.map { $0.dataCadastro }.max()
        
        return ExamSummary(
            totalExams: totalExams,
            recentExamsCount: recentExams.count,
            pendingExamsCount: pendingExams.count,
            lastExamDate: lastExamDate
        )
    }
    
    func fetchUserProfile() {
        print("🔄 HomeInteractor: Fetching user profile")
        
        // Fetch user from Firestore (which includes photoURL)
        userService.fetchCurrentUser { [weak self] result in
            switch result {
            case .success(let userModel):
                print("✅ HomeInteractor: User profile loaded from Firestore - \(userModel.displayName)")
                print("📸 HomeInteractor: photoURL from Firestore: \(userModel.photoURL ?? "nil")")
                
                // Convert UserModel to UserProfile
                let profile = UserProfile(
                    userId: userModel.uid,
                    name: userModel.nome,
                    email: userModel.email,
                    photoURL: userModel.photoURL, // This comes from Firestore
                    memberSince: userModel.dataCriacao
                )
                print("📸 HomeInteractor: profile.photoURL: \(profile.photoURL ?? "nil")")
                self?.output?.userProfileDidLoad(profile)
                
            case .failure(let error):
                print("❌ HomeInteractor: Failed to fetch user from Firestore - \(error.localizedDescription)")
                
                // Fallback to Firebase Auth data if Firestore fails
                if let authUser = Auth.auth().currentUser {
                    let profile = UserProfile(
                        userId: authUser.uid,
                        name: authUser.displayName,
                        email: authUser.email ?? "usuário@exemplo.com",
                        photoURL: authUser.photoURL?.absoluteString,
                        memberSince: authUser.metadata.creationDate ?? Date()
                    )
                    self?.output?.userProfileDidLoad(profile)
                } else {
                    self?.output?.userProfileDidFail(error: error)
                }
            }
        }
    }
    
    func fetchScheduledExams() {
        print("🔄 HomeInteractor: Fetching scheduled exams")
        
        exameService.fetchScheduledExams { [weak self] result in
            switch result {
            case .success(let exames):
                print("✅ HomeInteractor: Fetched \(exames.count) scheduled exams")
                
                // Limit to next 3 exams
                let nextExams = Array(exames.prefix(3))
                self?.output?.scheduledExamsDidLoad(nextExams)
                
            case .failure(let error):
                print("❌ HomeInteractor: Failed to fetch scheduled exams - \(error.localizedDescription)")
                // Don't fail the whole screen if scheduled exams fail
                // Just return empty array
                self?.output?.scheduledExamsDidLoad([])
            }
        }
    }
}


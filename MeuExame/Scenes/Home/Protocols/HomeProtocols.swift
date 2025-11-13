import UIKit

// MARK: - Home Protocols

/// Protocol for the Home View.
/// Extends `ViewProtocol` with specific methods for the Home screen.
protocol HomeViewProtocol: ViewProtocol {
    /// Updates the exam summary data
    /// - Parameter summary: Summary containing exam statistics
    func updateExamSummary(_ summary: ExamSummary)
    
    /// Updates the user profile data
    /// - Parameter profile: User profile information
    func updateUserProfile(_ profile: UserProfile)
    
    /// Updates the list of upcoming scheduled exams
    /// - Parameter exams: Array of scheduled exams (limited to next 3)
    func updateScheduledExams(_ exams: [ExameModel])
}

/// Protocol for the Home Presenter.
/// Extends `PresenterProtocol` with specific methods for handling Home UI events.
protocol HomePresenterProtocol: PresenterProtocol {
    /// Called when the user taps the Add Exam button
    func didTapAddExam()
    
    /// Called when the user taps the About button
    func didTapAbout()
    
    /// Called when the user taps their profile image
    func didTapProfile()
    
    /// Called when the view needs to refresh data
    func didRequestRefresh()
}

/// Protocol for the Home Interactor.
/// Extends `InteractorProtocol` with specific methods for Home business logic.
protocol HomeInteractorProtocol: InteractorProtocol {
    /// Fetches the exam summary data
    func fetchExamSummary()
    
    /// Fetches the user profile data
    func fetchUserProfile()
    
    /// Fetches the next scheduled exams (up to 3)
    func fetchScheduledExams()
}

/// Protocol for the Home Interactor's output.
/// Used by the Interactor to communicate results back to the Presenter.
protocol HomeInteractorOutputProtocol: AnyObject {
    /// Called when exam summary is successfully fetched
    /// - Parameter summary: The exam summary data
    func examSummaryDidLoad(_ summary: ExamSummary)
    
    /// Called when exam summary fetch fails
    /// - Parameter error: The error that occurred
    func examSummaryDidFail(error: Error)
    
    /// Called when user profile is successfully fetched
    /// - Parameter profile: The user profile data
    func userProfileDidLoad(_ profile: UserProfile)
    
    /// Called when user profile fetch fails
    /// - Parameter error: The error that occurred
    func userProfileDidFail(error: Error)
    
    /// Called when scheduled exams are successfully fetched
    /// - Parameter exams: Array of scheduled exams
    func scheduledExamsDidLoad(_ exams: [ExameModel])
    
    /// Called when scheduled exams fetch fails
    /// - Parameter error: The error that occurred
    func scheduledExamsDidFail(error: Error)
}

/// Protocol for the Home Router.
/// Extends `RouterProtocol` with specific navigation methods for the Home module.
protocol HomeRouterProtocol: RouterProtocol {
    /// Navigates to the Add Exam screen
    func navigateToAddExam()
    
    /// Navigates to the About screen
    func navigateToAbout()
    
    /// Navigates to the User Profile screen
    func navigateToUserProfile()
    
    /// Navigates to the Exam List screen
    func navigateToExamList()
}

// MARK: - Data Models

/// Exam summary data structure
struct ExamSummary {
    let totalExams: Int
    let recentExamsCount: Int
    let pendingExamsCount: Int
    let lastExamDate: Date?
    
    /// Formatted last exam date
    var formattedLastExamDate: String {
        guard let date = lastExamDate else {
            return "Nenhum exame cadastrado"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: date)
    }
    
    /// Default/empty summary
    static var empty: ExamSummary {
        return ExamSummary(
            totalExams: 0,
            recentExamsCount: 0,
            pendingExamsCount: 0,
            lastExamDate: nil
        )
    }
    
    /// Mock data for testing
    static var mock: ExamSummary {
        return ExamSummary(
            totalExams: 12,
            recentExamsCount: 3,
            pendingExamsCount: 2,
            lastExamDate: Date().addingTimeInterval(-86400 * 7) // 7 days ago
        )
    }
}

/// User profile data structure
struct UserProfile {
    let userId: String
    let name: String?
    let email: String
    let photoURL: String?
    let memberSince: Date
    
    /// Display name (email if name is not set)
    var displayName: String {
        return name ?? email.components(separatedBy: "@").first ?? "Usuário"
    }
    
    /// Formatted member since date
    var formattedMemberSince: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: memberSince)
    }
    
    /// Mock data for testing
    static func mock(userId: String = "user123") -> UserProfile {
        return UserProfile(
            userId: userId,
            name: "João Silva",
            email: "joao.silva@exemplo.com",
            photoURL: nil,
            memberSince: Date().addingTimeInterval(-86400 * 30) // 30 days ago
        )
    }
}


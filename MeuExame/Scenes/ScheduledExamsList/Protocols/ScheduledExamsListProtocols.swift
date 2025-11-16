import UIKit

// MARK: - ScheduledExamsList Protocols

/// Protocol for the ScheduledExamsList View.
/// Extends `ViewProtocol` with specific methods for the ScheduledExamsList screen.
protocol ScheduledExamsListViewProtocol: ViewProtocol {
    /// Updates the list of scheduled exams
    /// - Parameter exams: Array of scheduled exam models to display
    func updateScheduledExams(_ exams: [ExameModel])
    
    /// Shows empty state when no scheduled exams are found
    /// - Parameter message: Message to display
    func showEmptyState(_ message: String)
    
    /// Hides empty state
    func hideEmptyState()
}

/// Protocol for the ScheduledExamsList Presenter.
/// Extends `PresenterProtocol` with specific methods for handling ScheduledExamsList UI events.
protocol ScheduledExamsListPresenterProtocol: PresenterProtocol {
    /// Called when the user taps on an exam item
    /// - Parameter exam: The selected exam
    func didSelectExam(_ exam: ExameModel)
    
    /// Called when the user pulls to refresh
    func didPullToRefresh()
}

/// Protocol for the ScheduledExamsList Interactor.
/// Extends `InteractorProtocol` with specific methods for ScheduledExamsList business logic.
protocol ScheduledExamsListInteractorProtocol: InteractorProtocol {
    /// Fetches all scheduled exams from data source
    func fetchScheduledExams()
}

/// Protocol for the ScheduledExamsList Interactor's output.
/// Used by the Interactor to communicate results back to the Presenter.
protocol ScheduledExamsListInteractorOutputProtocol: AnyObject {
    /// Called when scheduled exams are successfully fetched
    /// - Parameter exams: Array of scheduled exams
    func scheduledExamsDidLoad(_ exams: [ExameModel])
    
    /// Called when scheduled exam fetch fails
    /// - Parameter error: The error that occurred
    func scheduledExamsDidFail(error: Error)
}

/// Protocol for the ScheduledExamsList Router.
/// Extends `RouterProtocol` with specific navigation methods for the ScheduledExamsList module.
protocol ScheduledExamsListRouterProtocol: RouterProtocol {
    /// Navigates to exam detail screen
    /// - Parameter exam: The exam to show details for
    func navigateToExamDetail(_ exam: ExameModel)
}


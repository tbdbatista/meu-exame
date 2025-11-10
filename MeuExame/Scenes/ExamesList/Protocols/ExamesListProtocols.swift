import UIKit

// MARK: - ExamesList Protocols

/// Protocol for the ExamesList View.
/// Extends `ViewProtocol` with specific methods for the ExamesList screen.
protocol ExamesListViewProtocol: ViewProtocol {
    /// Updates the list of exams
    /// - Parameter exams: Array of exam models to display
    func updateExames(_ exams: [ExameModel])
    
    /// Shows empty state when no exams are found
    /// - Parameter message: Message to display
    func showEmptyState(_ message: String)
    
    /// Hides empty state
    func hideEmptyState()
    
    /// Updates the search results
    /// - Parameter filteredExams: Filtered exam list
    func updateSearchResults(_ filteredExams: [ExameModel])
}

/// Protocol for the ExamesList Presenter.
/// Extends `PresenterProtocol` with specific methods for handling ExamesList UI events.
protocol ExamesListPresenterProtocol: PresenterProtocol {
    /// Called when the user taps on an exam item
    /// - Parameter exam: The selected exam
    func didSelectExam(_ exam: ExameModel)
    
    /// Called when the user taps the add button
    func didTapAddExam()
    
    /// Called when the user pulls to refresh
    func didPullToRefresh()
    
    /// Called when the user searches
    /// - Parameter searchText: The search query
    func didSearch(with searchText: String)
    
    /// Called when the user cancels search
    func didCancelSearch()
    
    /// Called when the user taps filter button
    func didTapFilter()
}

/// Protocol for the ExamesList Interactor.
/// Extends `InteractorProtocol` with specific methods for ExamesList business logic.
protocol ExamesListInteractorProtocol: InteractorProtocol {
    /// Fetches all exams from data source
    func fetchExames()
    
    /// Searches exams with given query
    /// - Parameter query: Search text
    func searchExames(with query: String)
    
    /// Deletes an exam
    /// - Parameter exam: Exam to delete
    func deleteExame(_ exam: ExameModel)
}

/// Protocol for the ExamesList Interactor's output.
/// Used by the Interactor to communicate results back to the Presenter.
protocol ExamesListInteractorOutputProtocol: AnyObject {
    /// Called when exams are successfully fetched
    /// - Parameter exams: Array of exams
    func examesDidLoad(_ exams: [ExameModel])
    
    /// Called when exam fetch fails
    /// - Parameter error: The error that occurred
    func examesDidFail(error: Error)
    
    /// Called when search results are ready
    /// - Parameter exams: Filtered exam list
    func searchResultsDidLoad(_ exams: [ExameModel])
    
    /// Called when exam is successfully deleted
    /// - Parameter exam: Deleted exam
    func exameDidDelete(_ exam: ExameModel)
    
    /// Called when delete fails
    /// - Parameter error: The error that occurred
    func exameDeleteDidFail(error: Error)
}

/// Protocol for the ExamesList Router.
/// Extends `RouterProtocol` with specific navigation methods for the ExamesList module.
protocol ExamesListRouterProtocol: RouterProtocol {
    /// Navigates to exam detail screen
    /// - Parameter exam: The exam to show details for
    func navigateToExamDetail(_ exam: ExameModel)
    
    /// Navigates to add exam screen
    func navigateToAddExam()
    
    /// Navigates to filter screen
    func navigateToFilter()
}


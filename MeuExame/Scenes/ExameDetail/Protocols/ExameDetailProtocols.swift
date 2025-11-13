import UIKit

// MARK: - ExameDetail Protocols

/// Protocol for the ExameDetail View.
/// Extends `ViewProtocol` with specific methods for the ExameDetail screen.
protocol ExameDetailViewProtocol: ViewProtocol {
    /// Updates the exam information displayed
    /// - Parameter exame: The exam model to display
    func updateExamInfo(_ exame: ExameModel)
    
    /// Shows the edit mode UI
    func showEditMode()
    
    /// Shows the view mode UI
    func showViewMode()
}

/// Protocol for the ExameDetail Presenter.
/// Extends `PresenterProtocol` with specific methods for handling ExameDetail UI events.
protocol ExameDetailPresenterProtocol: PresenterProtocol {
    /// Called when the user taps the edit button
    func didTapEdit()
    
    /// Called when the user taps the delete button
    func didTapDelete()
    
    /// Called when the user taps save (in edit mode)
    /// - Parameters:
    ///   - nome: Updated exam name
    ///   - local: Updated place
    ///   - medico: Updated doctor
    ///   - motivo: Updated reason
    ///   - data: Updated date
    ///   - scheduledDate: Optional scheduled date for future exams
    ///   - newFiles: Array of new files to attach (data and name tuples)
    func didTapSave(nome: String?, local: String?, medico: String?, motivo: String?, data: Date, isScheduled: Bool, newFiles: [(Data, String)])
    
    /// Called when the user taps cancel (in edit mode)
    func didTapCancel()
    
    /// Called when the user taps to view/download file
    /// - Parameter url: URL of the file to view
    func didTapViewFile(url: String)
    
    /// Called when the user taps to remove a file
    /// - Parameter index: Index of the file to remove
    func didTapRemoveFile(at index: Int)
    
    /// Called when the user taps share
    func didTapShare()
}

/// Protocol for the ExameDetail Interactor.
/// Extends `InteractorProtocol` with specific methods for ExameDetail business logic.
protocol ExameDetailInteractorProtocol: InteractorProtocol {
    /// Fetches the latest exam data
    /// - Parameter examId: ID of the exam to fetch
    func fetchExam(examId: String)
    
    /// Updates an existing exam
    /// - Parameters:
    ///   - exame: Updated exam model (with existing files)
    ///   - isScheduled: Whether the exam is scheduled (future) or completed (past)
    ///   - newFiles: Array of new files to attach (data and name tuples)
    func updateExam(_ exame: ExameModel, isScheduled: Bool, newFiles: [(Data, String)])
    
    /// Deletes an exam
    /// - Parameter examId: ID of the exam to delete
    func deleteExam(examId: String)
    
    /// Downloads the exam file
    /// - Parameter url: URL of the file to download
    func downloadFile(url: String)
}

/// Protocol for the ExameDetail Interactor's output.
/// Used by the Interactor to communicate results back to the Presenter.
protocol ExameDetailInteractorOutputProtocol: AnyObject {
    /// Called when exam is successfully fetched
    /// - Parameter exame: The fetched exam
    func examDidLoad(_ exame: ExameModel)
    
    /// Called when exam fetch fails
    /// - Parameter error: The error that occurred
    func examLoadDidFail(error: Error)
    
    /// Called when exam is successfully updated
    /// - Parameter exame: The updated exam
    func examDidUpdate(_ exame: ExameModel)
    
    /// Called when exam update fails
    /// - Parameter error: The error that occurred
    func examUpdateDidFail(error: Error)
    
    /// Called when exam is successfully deleted
    func examDidDelete()
    
    /// Called when exam delete fails
    /// - Parameter error: The error that occurred
    func examDeleteDidFail(error: Error)
    
    /// Called when file download completes
    /// - Parameter fileURL: Local URL of the downloaded file
    func fileDidDownload(fileURL: URL)
    
    /// Called when file download fails
    /// - Parameter error: The error that occurred
    func fileDownloadDidFail(error: Error)
}

/// Protocol for the ExameDetail Router.
/// Extends `RouterProtocol` with specific navigation methods for the ExameDetail module.
protocol ExameDetailRouterProtocol: RouterProtocol {
    /// Dismisses the detail screen
    func dismiss()
    
    /// Shows a confirmation alert for deletion
    /// - Parameter onConfirm: Callback when user confirms deletion
    func showDeleteConfirmation(onConfirm: @escaping () -> Void)
    
    /// Shows file viewer
    /// - Parameter fileURL: URL of the file to view
    func showFileViewer(fileURL: URL)
    
    /// Shows share sheet
    /// - Parameter items: Items to share
    func showShareSheet(items: [Any])
}


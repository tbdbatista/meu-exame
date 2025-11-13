import UIKit

// MARK: - AddExam Protocols

/// Protocol for the AddExam View.
/// Extends `ViewProtocol` with specific methods for the AddExam screen.
protocol AddExamViewProtocol: ViewProtocol {
    /// Clears all form fields
    func clearForm()
    
    /// Shows validation error for a specific field
    /// - Parameters:
    ///   - field: The field name
    ///   - message: Error message
    func showFieldError(field: String, message: String)
    
    /// Hides validation error for a specific field
    /// - Parameter field: The field name
    func hideFieldError(field: String)
    
    /// Updates the file attachment UI
    /// - Parameters:
    ///   - fileName: Name of the attached file
    ///   - hasFile: Whether a file is attached
    func updateFileAttachment(fileName: String?, hasFile: Bool)
}

/// Protocol for the AddExam Presenter.
/// Extends `PresenterProtocol` with specific methods for handling AddExam UI events.
protocol AddExamPresenterProtocol: PresenterProtocol {
    /// Called when the user taps the save/create button
    /// - Parameters:
    ///   - nome: Exam name
    ///   - local: Place where exam was performed
    ///   - medico: Doctor who requested the exam
    ///   - motivo: Reason/complaint
    ///   - data: Date of the exam
    ///   - isScheduled: Whether the exam is scheduled (future) or completed (past)
    ///   - fileData: Optional file data (image/PDF)
    ///   - fileName: Optional file name
    func didTapSave(nome: String?, local: String?, medico: String?, motivo: String?, data: Date, isScheduled: Bool, fileData: Data?, fileName: String?)
    
    /// Called when the user taps attach file button
    func didTapAttachFile()
    
    /// Called when the user taps remove file button
    func didTapRemoveFile()
    
    /// Called when the user taps cancel button
    func didTapCancel()
}

/// Protocol for the AddExam Interactor.
/// Extends `InteractorProtocol` with specific methods for AddExam business logic.
protocol AddExamInteractorProtocol: InteractorProtocol {
    /// Creates a new exam
    /// - Parameters:
    ///   - exame: Exam model to create
    ///   - fileData: Optional file data to upload
    ///   - fileName: Optional file name
    func createExam(exame: ExameModel, isScheduled: Bool, fileData: Data?, fileName: String?)
}

/// Protocol for the AddExam Interactor's output.
/// Used by the Interactor to communicate results back to the Presenter.
protocol AddExamInteractorOutputProtocol: AnyObject {
    /// Called when exam is successfully created
    /// - Parameter exame: The created exam
    func examDidCreate(_ exame: ExameModel)
    
    /// Called when exam creation fails
    /// - Parameter error: The error that occurred
    func examCreateDidFail(error: Error)
    
    /// Called to report upload progress
    /// - Parameter progress: Upload progress (0.0 to 1.0)
    func uploadProgressDidUpdate(progress: Double)
}

/// Protocol for the AddExam Router.
/// Extends `RouterProtocol` with specific navigation methods for the AddExam module.
protocol AddExamRouterProtocol: RouterProtocol {
    /// Dismisses the add exam screen
    func dismiss()
    
    /// Shows file picker
    func showFilePicker()
}

// MARK: - Validation

/// Validation result for exam form
struct ExamValidationResult {
    let isValid: Bool
    let errors: [String: String] // field: errorMessage
    
    static var valid: ExamValidationResult {
        return ExamValidationResult(isValid: true, errors: [:])
    }
    
    static func invalid(errors: [String: String]) -> ExamValidationResult {
        return ExamValidationResult(isValid: false, errors: errors)
    }
}


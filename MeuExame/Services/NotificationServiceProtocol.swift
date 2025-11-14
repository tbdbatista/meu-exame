import Foundation
import UserNotifications

/// Protocol defining the contract for local notification service operations.
protocol NotificationServiceProtocol {
    /// Requests authorization for local notifications
    /// - Parameter completion: Completion handler with authorization status
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void)
    
    /// Schedules a notification for a scheduled exam
    /// - Parameters:
    ///   - examId: The unique identifier of the exam
    ///   - examName: The name of the exam
    ///   - scheduledDate: The date when the exam is scheduled
    ///   - completion: Completion handler with Result indicating success or error
    func scheduleExamNotification(examId: String, examName: String, scheduledDate: Date, completion: @escaping (Result<String, NotificationError>) -> Void)
    
    /// Cancels a scheduled notification for an exam
    /// - Parameter examId: The unique identifier of the exam
    func cancelExamNotification(examId: String)
    
    /// Cancels all scheduled notifications for exams
    func cancelAllExamNotifications()
    
    /// Gets all pending notifications
    /// - Parameter completion: Completion handler with array of notification identifiers
    func getPendingNotifications(completion: @escaping ([String]) -> Void)
}

/// Error types for Notification Service operations
enum NotificationError: Error {
    case notAuthorized
    case schedulingFailed
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .notAuthorized:
            return "Permissão para notificações não concedida."
        case .schedulingFailed:
            return "Falha ao agendar notificação."
        case .unknown(let error):
            return "Erro desconhecido: \(error.localizedDescription)"
        }
    }
}


import Foundation
import UserNotifications

/// Service implementation for managing local notifications.
/// Handles scheduling, canceling, and managing exam reminder notifications.
final class LocalNotificationService: NotificationServiceProtocol {
    
    // MARK: - Properties
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let examNotificationCategory = "EXAM_REMINDER"
    
    // MARK: - NotificationServiceProtocol Implementation
    
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        print("🔔 LocalNotificationService: Requesting authorization")
        
        notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("❌ LocalNotificationService: Authorization error - \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            if granted {
                print("✅ LocalNotificationService: Authorization granted")
                self.setupNotificationCategories()
            } else {
                print("⚠️ LocalNotificationService: Authorization denied")
            }
            
            completion(granted, error)
        }
    }
    
    func scheduleExamNotification(examId: String, examName: String, scheduledDate: Date, completion: @escaping (Result<String, NotificationError>) -> Void) {
        print("📅 LocalNotificationService: Scheduling notification for exam '\(examName)' on \(scheduledDate)")
        
        // Check if date is in the future
        guard scheduledDate > Date() else {
            print("⚠️ LocalNotificationService: Scheduled date is in the past, skipping notification")
            completion(.failure(.schedulingFailed))
            return
        }
        
        // Request authorization first
        notificationCenter.getNotificationSettings { [weak self] settings in
            guard let self = self else { return }
            
            guard settings.authorizationStatus == .authorized else {
                print("❌ LocalNotificationService: Not authorized for notifications")
                completion(.failure(.notAuthorized))
                return
            }
            
            // Create notification content
            let content = UNMutableNotificationContent()
            content.title = "📋 Lembrete de Exame"
            content.body = "Você tem um exame agendado: \(examName)"
            content.sound = .default
            content.categoryIdentifier = self.examNotificationCategory
            content.userInfo = [
                "examId": examId,
                "examName": examName,
                "scheduledDate": scheduledDate.timeIntervalSince1970
            ]
            
            // Schedule notification 1 day before
            let oneDayBefore = scheduledDate.addingTimeInterval(-86400) // 24 hours before
            let triggerDate = max(oneDayBefore, Date().addingTimeInterval(60)) // At least 1 minute from now
            
            let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: triggerDate)
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            
            // Also schedule a notification on the day of the exam (at 8 AM)
            let examDayComponents = Calendar.current.dateComponents([.year, .month, .day], from: scheduledDate)
            var examDayTriggerComponents = examDayComponents
            examDayTriggerComponents.hour = 8
            examDayTriggerComponents.minute = 0
            
            let examDayTrigger = UNCalendarNotificationTrigger(dateMatching: examDayTriggerComponents, repeats: false)
            
            // Create requests
            let reminderRequest = UNNotificationRequest(
                identifier: "\(examId)_reminder",
                content: content,
                trigger: trigger
            )
            
            let dayOfRequest = UNNotificationRequest(
                identifier: "\(examId)_day",
                content: content,
                trigger: examDayTrigger
            )
            
            // Add both notifications
            self.notificationCenter.add(reminderRequest) { error in
                if let error = error {
                    print("❌ LocalNotificationService: Failed to schedule reminder - \(error.localizedDescription)")
                    completion(.failure(.unknown(error)))
                    return
                }
                
                self.notificationCenter.add(dayOfRequest) { error in
                    if let error = error {
                        print("❌ LocalNotificationService: Failed to schedule day-of notification - \(error.localizedDescription)")
                        completion(.failure(.unknown(error)))
                        return
                    }
                    
                    print("✅ LocalNotificationService: Notifications scheduled successfully")
                    completion(.success(examId))
                }
            }
        }
    }
    
    func cancelExamNotification(examId: String) {
        print("🗑️ LocalNotificationService: Canceling notifications for exam '\(examId)'")
        
        let identifiers = [
            "\(examId)_reminder",
            "\(examId)_day"
        ]
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: identifiers)
        print("✅ LocalNotificationService: Notifications canceled")
    }
    
    func cancelAllExamNotifications() {
        print("🗑️ LocalNotificationService: Canceling all exam notifications")
        
        notificationCenter.getPendingNotificationRequests { requests in
            let examIdentifiers = requests
                .filter { $0.content.categoryIdentifier == self.examNotificationCategory }
                .map { $0.identifier }
            
            self.notificationCenter.removePendingNotificationRequests(withIdentifiers: examIdentifiers)
            print("✅ LocalNotificationService: All exam notifications canceled (\(examIdentifiers.count) removed)")
        }
    }
    
    func getPendingNotifications(completion: @escaping ([String]) -> Void) {
        notificationCenter.getPendingNotificationRequests { requests in
            let examIdentifiers = requests
                .filter { $0.content.categoryIdentifier == self.examNotificationCategory }
                .compactMap { $0.content.userInfo["examId"] as? String }
            
            completion(Array(Set(examIdentifiers))) // Remove duplicates
        }
    }
    
    // MARK: - Private Helpers
    
    private func setupNotificationCategories() {
        let viewAction = UNNotificationAction(
            identifier: "VIEW_EXAM",
            title: "Ver Exame",
            options: [.foreground]
        )
        
        let category = UNNotificationCategory(
            identifier: examNotificationCategory,
            actions: [viewAction],
            intentIdentifiers: [],
            options: []
        )
        
        notificationCenter.setNotificationCategories([category])
        print("✅ LocalNotificationService: Notification categories set up")
    }
}


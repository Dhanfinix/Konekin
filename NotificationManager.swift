import Foundation
import UserNotifications
import Cocoa

class NotificationManager {
    static let shared = NotificationManager()
    
    private init() {
        requestAuthorization()
    }
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Notification permission error: \(error.localizedDescription)")
            }
        }
    }
    
    func show(title: String, body: String, isError: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        if isError {
             // In a more advanced app we could attach an image or change the sound
        }
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil) // nil trigger = immediate
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Failed to show notification: \(error.localizedDescription)")
            }
        }
    }
}

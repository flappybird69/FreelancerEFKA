import SwiftUI
import UserNotifications

@Observable
final class NotificationManager {
    var isAuthorized = false
    var showDeniedAlert = false

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            DispatchQueue.main.async {
                self.isAuthorized = granted
                if !granted { self.showDeniedAlert = true }
            }
        }
    }

    func scheduleDeadlines() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        let deadlines: [(String, DateComponents, String)] = [
            ("EFKA Payment Due", DateComponents(hour: 9, minute: 0, weekday: 1),
             "Your monthly EFKA contribution is due soon. Pay via myEFKA."),
            ("VAT Return Due", DateComponents(month: 4, day: 25, hour: 9, minute: 0),
             "Q1 VAT return (ΦΠΑ) due April 30."),
            ("VAT Return Due", DateComponents(month: 7, day: 25, hour: 9, minute: 0),
             "Q2 VAT return (ΦΠΑ) due July 31."),
            ("VAT Return Due", DateComponents(month: 10, day: 25, hour: 9, minute: 0),
             "Q3 VAT return (ΦΠΑ) due October 31."),
            ("VAT Return Due", DateComponents(month: 1, day: 25, hour: 9, minute: 0),
             "Q4 VAT return (ΦΠΑ) due January 31."),
            ("Income Tax Filing", DateComponents(month: 3, day: 20, hour: 9, minute: 0),
             "Annual income tax filing (Ε1) opens. File via myTAXISnet by April 30."),
        ]

        for (title, dateComp, body) in deadlines {
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = body
            content.sound = .default
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComp, repeats: true)
            let request = UNNotificationRequest(identifier: "efka_\(title)_\(body.prefix(10))", content: content, trigger: trigger)
            center.add(request)
        }

        // Weekly reminder every Monday at 9am
        let weeklyContent = UNMutableNotificationContent()
        weeklyContent.title = "Weekly Reminder"
        weeklyContent.body = "Check your μπλοκάκι receipts and log any expenses."
        weeklyContent.sound = .default
        let weeklyTrigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 9, minute: 0, weekday: 2), repeats: true)
        center.add(UNNotificationRequest(identifier: "weekly_reminder", content: weeklyContent, trigger: weeklyTrigger))
    }

    func checkAuthorization() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                self.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
}

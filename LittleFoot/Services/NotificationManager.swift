import UserNotifications
import Foundation

enum NotificationManager {
    static func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, _ in }
    }

    static func scheduleDailyNotifications(babyName: String, birthday: Date) {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()

        // Schedule next 7 days of notifications
        for dayOffset in 0..<7 {
            guard let futureDate = Calendar.current.date(byAdding: .day, value: dayOffset, to: Date()) else { continue }
            let dayOfLife = (Calendar.current.dateComponents([.day], from: birthday, to: futureDate).day ?? 0) + 1

            guard dayOfLife >= 1 && dayOfLife <= 365 else { continue }

            let activity = Activities.forDay(dayOfLife)

            let content = UNMutableNotificationContent()
            content.title = "Little Foot 🦶"
            content.subtitle = "\(babyName) — Day \(dayOfLife)"
            content.body = "\(activity.name): \(activity.description)"
            content.sound = .default

            var triggerDate = Calendar.current.dateComponents([.year, .month, .day], from: futureDate)
            triggerDate.hour = 8
            triggerDate.minute = 0

            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            let request = UNNotificationRequest(
                identifier: "littlefoot-day-\(dayOfLife)",
                content: content,
                trigger: trigger
            )
            center.add(request)
        }
    }
}

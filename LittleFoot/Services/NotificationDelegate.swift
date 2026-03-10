import UserNotifications

@Observable
final class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    var pendingDayOfLife: Int?

    func userNotificationCenter(
        _: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        if let day = response.notification.request.content.userInfo["dayOfLife"] as? Int {
            pendingDayOfLife = day
        }
        completionHandler()
    }
}

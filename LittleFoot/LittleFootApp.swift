import SwiftUI
import SwiftData
import UserNotifications

@main
struct LittleFootApp: App {
    @State private var notificationDelegate = NotificationDelegate()

    init() {
        UNUserNotificationCenter.current().delegate = notificationDelegate
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(notificationDelegate)
        }
        .modelContainer(for: [BabyProfile.self, FavoriteActivity.self])
    }
}

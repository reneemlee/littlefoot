import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [BabyProfile]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if let profile = profiles.first {
                DashboardView(profile: profile)
                    .task {
                        NotificationManager.scheduleDailyNotifications(
                            babyName: profile.name,
                            birthday: profile.birthday
                        )
                    }
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut, value: profiles.isEmpty)
    }
}

import SwiftUI
import SwiftData

@main
struct LittleFootApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [BabyProfile.self, FavoriteActivity.self])
    }
}

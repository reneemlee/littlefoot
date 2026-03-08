import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var profiles: [BabyProfile]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedTab = 0

    private let communityURL = URL(string: "https://www.facebook.com/groups/1282544283776390")!

    var body: some View {
        Group {
            if let profile = profiles.first {
                Group {
                    switch selectedTab {
                    case 0:
                        NavigationStack {
                            DashboardView(profile: profile)
                        }
                    case 2:
                        NavigationStack {
                            SettingsView(profile: profile)
                        }
                    default:
                        NavigationStack {
                            DashboardView(profile: profile)
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    HStack(spacing: 0) {
                        tabButton(systemIcon: "sparkles", tag: 0)
                        tabButton(systemIcon: "heart.circle", tag: 1)
                        tabButton(systemIcon: "gearshape", tag: 2)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 14)
                    .padding(.bottom, 10)
                    .background(
                        Theme.background
                            .shadow(color: .black.opacity(0.06), radius: 8, y: -4)
                            .ignoresSafeArea(.container, edges: .bottom)
                    )
                }
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

    private func tabButton(systemIcon: String, tag: Int) -> some View {
        Button {
            if tag == 1 {
                UIApplication.shared.open(communityURL)
            } else {
                selectedTab = tag
            }
        } label: {
            let isSelected = selectedTab == tag
            Image(systemName: isSelected ? systemIcon : systemIcon)
                .font(.system(size: 22, weight: isSelected ? .semibold : .regular))
                .foregroundColor(isSelected ? Theme.primary : Theme.text.opacity(0.3))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? Theme.primary.opacity(0.12) : .clear)
                        .frame(width: 44, height: 44)
                )
                .contentShape(Circle())
                .frame(maxWidth: .infinity)
        }
    }
}

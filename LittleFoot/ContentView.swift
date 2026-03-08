import SwiftUI
import SwiftData
import PhosphorSwift

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
                        tabButton(icon: Ph.lightbulb.regular, tag: 0)
                        tabButton(icon: Ph.users.regular, tag: 1)
                        tabButton(icon: Ph.gearSix.regular, tag: 2)
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 8)
                    .background(
                        Capsule()
                            .fill(.ultraThinMaterial)
                            .overlay(
                                Capsule()
                                    .strokeBorder(
                                        LinearGradient(
                                            colors: [
                                                .white.opacity(0.6),
                                                .white.opacity(0.1),
                                            ],
                                            startPoint: .top,
                                            endPoint: .bottom
                                        ),
                                        lineWidth: 0.5
                                    )
                            )
                            .shadow(color: .black.opacity(0.08), radius: 16, y: 8)
                    )
                    .padding(.horizontal, 48)
                    .padding(.bottom, 4)
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

    private func tabButton(icon: Image, tag: Int) -> some View {
        Button {
            if tag == 1 {
                UIApplication.shared.open(communityURL)
            } else {
                selectedTab = tag
            }
        } label: {
            let isSelected = selectedTab == tag
            icon
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(isSelected ? Theme.primary : Theme.text.opacity(0.3))
                .frame(width: 44, height: 44)
                .background(
                    Circle()
                        .fill(isSelected ? Theme.primary.opacity(0.12) : .clear)
                )
                .contentShape(Circle())
                .frame(maxWidth: .infinity)
        }
    }
}

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
                    VStack(spacing: 0) {
                        Divider()
                        HStack(spacing: 0) {
                            tabButton(
                                systemIcon: "star.fill",
                                label: "Today",
                                tag: 0
                            )

                            tabButton(
                                systemIcon: "person.3.fill",
                                label: "Community",
                                tag: 1
                            )

                            tabButton(
                                systemIcon: "gearshape.fill",
                                label: "Settings",
                                tag: 2
                            )
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 8)
                    }
                    .background(
                        Theme.background
                            .shadow(color: .black.opacity(0.05), radius: 4, y: -2)
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

    private func tabButton(systemIcon: String, label: String, tag: Int) -> some View {
        Button {
            if tag == 1 {
                UIApplication.shared.open(communityURL)
            } else {
                selectedTab = tag
            }
        } label: {
            VStack(spacing: 4) {
                Image(systemName: systemIcon)
                    .font(.system(size: 20))
                    .frame(width: 22, height: 22)

                Text(label)
                    .font(.system(size: 10, design: .rounded))
            }
            .foregroundColor(selectedTab == tag ? Theme.primary : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}

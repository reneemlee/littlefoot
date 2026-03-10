import SwiftUI
import SwiftData
import PhosphorSwift

struct ContentView: View {
    @Query private var profiles: [BabyProfile]
    @Environment(\.modelContext) private var modelContext

    @Environment(NotificationDelegate.self) private var notificationDelegate
    @State private var selectedTab = 0
    @State private var navigationPath = NavigationPath()

    private let communityURL = URL(string: "https://www.facebook.com/groups/1282544283776390")!

    var body: some View {
        Group {
            if let profile = profiles.first {
                Group {
                    switch selectedTab {
                    case 0:
                        NavigationStack(path: $navigationPath) {
                            DashboardView(profile: profile)
                                .navigationDestination(for: Int.self) { day in
                                    ActivityDetailView(
                                        activity: Activities.forDay(day),
                                        date: Calendar.current.date(
                                            byAdding: .day,
                                            value: day - 1,
                                            to: profile.birthday
                                        ) ?? Date(),
                                        dayOfLife: day
                                    )
                                }
                        }
                    case 1:
                        NavigationStack {
                            FavoritesView(profile: profile)
                        }
                    default:
                        NavigationStack(path: $navigationPath) {
                            DashboardView(profile: profile)
                        }
                    }
                }
                .safeAreaInset(edge: .bottom) {
                    HStack(spacing: 0) {
                        tabButton(icon: Ph.lightbulb.regular, tag: 0)
                        tabButton(icon: Ph.heart.regular, tag: 1)
                        tabButton(icon: Ph.users.regular, tag: 2)
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
                .onChange(of: notificationDelegate.pendingDayOfLife, initial: true) { _, day in
                    guard let day else { return }
                    selectedTab = 0
                    navigationPath.removeLast(navigationPath.count)
                    navigationPath.append(day)
                    notificationDelegate.pendingDayOfLife = nil
                }
            } else {
                OnboardingView()
            }
        }
        .animation(.easeInOut, value: profiles.isEmpty)
    }

    private func tabButton(icon: Image, tag: Int) -> some View {
        Button {
            if tag == 2 {
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

import SwiftUI
import PhosphorSwift

struct SettingsView: View {
    let profile: BabyProfile

    @Environment(\.modelContext) private var modelContext
    @State private var notificationsEnabled = true

    private let contactEmail = "renee@withlychee.com"
    private let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"

    var body: some View {
        List {
                Section {
                    HStack(spacing: 16) {
                        Ph.baby.fill
                            .frame(width: 24, height: 24)
                            .color(Theme.primary)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(profile.name)
                                .font(Theme.headline)
                                .foregroundColor(Theme.text)

                            Text(profile.ageDescription)
                                .font(Theme.caption)
                                .foregroundColor(Theme.textLight)
                        }
                    }
                    .padding(.vertical, 4)
                } header: {
                    Text("Baby")
                }

                Section {
                    Toggle(isOn: $notificationsEnabled) {
                        HStack(spacing: 16) {
                            Ph.bellRinging.fill
                                .frame(width: 24, height: 24)
                                .color(Theme.secondary)

                            Text("Daily Reminders")
                                .font(Theme.body)
                                .foregroundColor(Theme.text)
                        }
                    }
                    .tint(Theme.primary)
                    .onChange(of: notificationsEnabled) { _, enabled in
                        if enabled {
                            NotificationManager.requestPermission()
                            NotificationManager.scheduleDailyNotifications(
                                babyName: profile.name,
                                birthday: profile.birthday
                            )
                        } else {
                            NotificationManager.cancelAll()
                        }
                    }
                } header: {
                    Text("Notifications")
                }

                Section {
                    Button {
                        sendContactEmail()
                    } label: {
                        HStack(spacing: 16) {
                            Ph.envelope.fill
                                .frame(width: 24, height: 24)
                                .color(Theme.primary)

                            Text("Contact Us")
                                .font(Theme.body)
                                .foregroundColor(Theme.text)

                            Spacer()

                            Ph.caretRight.bold
                                .frame(width: 16, height: 16)
                                .color(Theme.textLight)
                        }
                    }
                } header: {
                    Text("Support")
                }

                Section {
                    HStack {
                        Text("Version")
                            .font(Theme.body)
                            .foregroundColor(Theme.text)

                        Spacer()

                        Text(appVersion)
                            .font(Theme.body)
                            .foregroundColor(Theme.textLight)
                    }
                } header: {
                    Text("About")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func sendContactEmail() {
        let subject = "Little Foot Feedback"
        let encodedSubject = subject.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? subject
        if let url = URL(string: "mailto:\(contactEmail)?subject=\(encodedSubject)") {
            UIApplication.shared.open(url)
        }
    }
}

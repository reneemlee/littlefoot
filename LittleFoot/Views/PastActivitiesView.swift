import SwiftUI
import PhosphorSwift

struct PastActivitiesView: View {
    let profile: BabyProfile

    @State private var selectedDate: Date = Date()

    private var minDate: Date { profile.birthday }
    private var maxDate: Date { Date() }

    private func dayOfLife(for date: Date) -> Int {
        let days = Calendar.current.dateComponents([.day], from: profile.birthday, to: date).day ?? 0
        return max(1, days + 1)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                DatePicker(
                    "Select a date",
                    selection: $selectedDate,
                    in: minDate...maxDate,
                    displayedComponents: .date
                )
                .datePickerStyle(.graphical)
                .tint(Theme.primary)
                .padding(.horizontal, Theme.screenPadding)

                let day = dayOfLife(for: selectedDate)
                let activity = Activities.forDay(day)

                NavigationLink {
                    ActivityDetailView(
                        activity: activity,
                        date: selectedDate,
                        dayOfLife: day
                    )
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Day \(day)")
                                .font(Theme.caption)
                                .foregroundColor(Theme.textLight)
                                .textCase(.uppercase)

                            Text(activity.name)
                                .font(Theme.headline)
                                .foregroundColor(Theme.text)
                                .multilineTextAlignment(.leading)
                        }

                        Spacer()

                        Ph.caretRight.bold
                            .frame(width: 16, height: 16)
                            .color(Theme.textLight)
                    }
                    .padding(Theme.cardPadding)
                    .background(Theme.cardBackground)
                    .cornerRadius(Theme.cornerRadius)
                    .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
                }
                .padding(.horizontal, Theme.screenPadding)

                Spacer(minLength: 40)
            }
        }
        .background(Theme.background)
        .navigationTitle("Past Activities")
        .navigationBarTitleDisplayMode(.inline)
    }
}

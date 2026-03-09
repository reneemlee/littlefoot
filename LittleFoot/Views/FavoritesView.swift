import SwiftUI
import SwiftData
import PhosphorSwift

struct FavoritesView: View {
    let profile: BabyProfile
    @Query(sort: \FavoriteActivity.dateAdded, order: .reverse) private var favorites: [FavoriteActivity]
    @Environment(\.modelContext) private var modelContext

    @State private var selectedSegment = 0
    @State private var selectedDate: Date = Date()

    private var minDate: Date { profile.birthday }
    private var maxDate: Date { Date() }

    private func dayOfLife(for date: Date) -> Int {
        let days = Calendar.current.dateComponents([.day], from: profile.birthday, to: date).day ?? 0
        return max(1, days + 1)
    }

    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection: $selectedSegment) {
                Text("Favorites").tag(0)
                Text("Calendar").tag(1)
            }
            .pickerStyle(.segmented)
            .padding(.horizontal, Theme.screenPadding)
            .padding(.top, 12)
            .padding(.bottom, 8)

            if selectedSegment == 0 {
                favoritesListView
            } else {
                calendarView
            }
        }
        .background(Theme.background)
        .navigationBarHidden(true)
    }

    // MARK: - Favorites List

    private var favoritesListView: some View {
        Group {
            if favorites.isEmpty {
                VStack(spacing: 16) {
                    Spacer()
                    Ph.heart.regular
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 48, height: 48)
                        .foregroundColor(Theme.textLight.opacity(0.4))

                    Text("No favorites yet")
                        .font(Theme.headline)
                        .foregroundColor(Theme.textLight)

                    Text("Tap the heart on any activity\nto save it here")
                        .font(Theme.body)
                        .foregroundColor(Theme.textLight.opacity(0.6))
                        .multilineTextAlignment(.center)
                    Spacer()
                }
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(favorites) { favorite in
                            let activity = Activities.forDay(favorite.dayNumber)
                            NavigationLink {
                                ActivityDetailView(
                                    activity: activity,
                                    date: Calendar.current.date(
                                        byAdding: .day,
                                        value: favorite.dayNumber - 1,
                                        to: profile.birthday
                                    ) ?? Date(),
                                    dayOfLife: favorite.dayNumber
                                )
                            } label: {
                                favoriteRow(activity: activity, dayNumber: favorite.dayNumber, favorite: favorite)
                            }
                        }
                    }
                    .padding(.horizontal, Theme.screenPadding)
                    .padding(.top, 8)
                    .padding(.bottom, 40)
                }
            }
        }
    }

    private func favoriteRow(activity: Activity, dayNumber: Int, favorite: FavoriteActivity) -> some View {
        HStack(spacing: 12) {
            Image(activity.doodle)
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text("Day \(dayNumber)")
                    .font(Theme.caption)
                    .foregroundColor(Theme.textLight)
                    .textCase(.uppercase)

                Text(activity.name)
                    .font(Theme.headline)
                    .foregroundColor(Theme.text)
                    .multilineTextAlignment(.leading)
            }

            Spacer()

            Button {
                modelContext.delete(favorite)
            } label: {
                Ph.heart.fill
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundColor(Theme.primary)
            }
        }
        .padding(Theme.cardPadding)
        .background(Color.white)
        .cornerRadius(Theme.cornerRadius)
        .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
    }

    // MARK: - Calendar

    private var calendarView: some View {
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
                            .renderingMode(.template)
                            .frame(width: 16, height: 16)
                            .foregroundColor(Theme.textLight)
                    }
                    .padding(Theme.cardPadding)
                    .background(Color.white)
                    .cornerRadius(Theme.cornerRadius)
                    .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
                }
                .padding(.horizontal, Theme.screenPadding)

                Spacer(minLength: 40)
            }
        }
    }
}

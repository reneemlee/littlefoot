import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity
    let date: Date
    let dayOfLife: Int

    private var formattedDate: String {
        date.formatted(date: .long, time: .omitted)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Text(formattedDate)
                        .font(Theme.body)
                        .foregroundColor(Theme.textLight)

                    Text("Day \(dayOfLife)")
                        .font(Theme.headline)
                        .foregroundColor(Theme.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Theme.primary.opacity(0.12))
                        .cornerRadius(20)
                }
                .padding(.top, 20)

                VStack(alignment: .leading, spacing: 16) {
                    Image(activity.doodle)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 180)
                        .frame(maxWidth: .infinity)

                    Text(activity.name)
                        .font(Theme.title)
                        .foregroundColor(Theme.text)

                    Text(activity.description)
                        .font(Theme.body)
                        .foregroundColor(Theme.text)
                        .lineSpacing(4)

                    if !activity.accessories.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("You'll need")
                                .font(Theme.caption)
                                .foregroundColor(Theme.textLight)
                                .textCase(.uppercase)

                            FlowLayout(spacing: 8) {
                                ForEach(activity.accessories, id: \.self) { accessory in
                                    Text(accessory)
                                        .font(Theme.caption)
                                        .foregroundColor(Theme.secondary)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Theme.secondary.opacity(0.12))
                                        .cornerRadius(20)
                                }
                            }
                        }
                    }
                }
                .padding(Theme.cardPadding)
                .background(Color.white)
                .cornerRadius(Theme.cornerRadius)
                .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
                .padding(.horizontal, Theme.screenPadding)

                Spacer(minLength: 40)
            }
        }
        .background(Theme.background)
        .navigationBarTitleDisplayMode(.inline)
    }
}

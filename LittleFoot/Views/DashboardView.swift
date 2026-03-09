import SwiftUI
import SwiftData
import PhosphorSwift

struct DashboardView: View {
    let profile: BabyProfile
    @Query private var favorites: [FavoriteActivity]
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) private var colorScheme

    private var dayOfLife: Int { profile.dayOfLife }
    private var activity: Activity { Activities.forDay(dayOfLife) }

    private var isFavorited: Bool {
        favorites.contains { $0.dayNumber == dayOfLife }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 8) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .clipShape(RoundedRectangle(cornerRadius: 16))

                    Text(profile.name)
                        .font(Theme.largeTitle)
                        .foregroundColor(Theme.text)

                    Text(profile.ageDescription)
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
                .padding(.top, 12)

                // Today's Activity Card
                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Text("Today's Activity")
                            .font(Theme.caption)
                            .foregroundColor(Theme.textLight)
                            .textCase(.uppercase)
                        Spacer()
                        Button {
                            toggleFavorite()
                        } label: {
                            (isFavorited ? Ph.heart.fill : Ph.heart.regular)
                                .renderingMode(.template)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                                .foregroundColor(isFavorited ? Theme.primary : Theme.textLight)
                        }
                    }

                    Image(activity.doodle)
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 180)
                        .doodleStyle(colorScheme)
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
                .background(Theme.cardBackground)
                .cornerRadius(Theme.cornerRadius)
                .shadow(color: .black.opacity(0.06), radius: 12, y: 6)
                .padding(.horizontal, Theme.screenPadding)

                Spacer(minLength: 40)
            }
        }
        .background(Theme.background)
        .navigationBarHidden(true)
        .overlay(alignment: .topTrailing) {
            NavigationLink {
                SettingsView(profile: profile)
            } label: {
                Ph.gearSix.regular
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 22, height: 22)
                    .foregroundColor(Theme.primary)
                    .frame(width: 40, height: 40)
                    .background(Theme.background)
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.08), radius: 4, y: 2)
            }
            .padding(.trailing, Theme.screenPadding)
            .padding(.top, 8)
        }
    }

    private func toggleFavorite() {
        if let existing = favorites.first(where: { $0.dayNumber == dayOfLife }) {
            modelContext.delete(existing)
        } else {
            modelContext.insert(FavoriteActivity(dayNumber: dayOfLife))
        }
    }
}

// Simple flow layout for accessory tags
struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: ProposedViewSize(width: bounds.width, height: bounds.height), subviews: subviews)
        for (index, position) in result.positions.enumerated() {
            subviews[index].place(at: CGPoint(x: bounds.minX + position.x, y: bounds.minY + position.y), proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (size: CGSize, positions: [CGPoint]) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        var maxX: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth && x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
            maxX = max(maxX, x)
        }

        return (CGSize(width: maxX, height: y + rowHeight), positions)
    }
}

import SwiftUI

enum Theme {
    // Colors
    static let background = Color(red: 1.0, green: 0.973, blue: 0.941)       // #FFF8F0
    static let primary = Color(red: 0.910, green: 0.588, blue: 0.478)        // #E8967A
    static let secondary = Color(red: 0.537, green: 0.690, blue: 0.627)      // #89B0A0
    static let accent = Color(red: 0.957, green: 0.780, blue: 0.478)         // #F4C77A
    static let text = Color(red: 0.290, green: 0.247, blue: 0.208)           // #4A3F35
    static let textLight = Color(red: 0.290, green: 0.247, blue: 0.208).opacity(0.6)

    // Typography
    static let largeTitle = Font.system(.largeTitle, design: .rounded, weight: .bold)
    static let title = Font.system(.title2, design: .rounded, weight: .bold)
    static let headline = Font.system(.headline, design: .rounded, weight: .semibold)
    static let body = Font.system(.body, design: .rounded)
    static let caption = Font.system(.caption, design: .rounded)

    // Layout
    static let cornerRadius: CGFloat = 16
    static let cardPadding: CGFloat = 20
    static let screenPadding: CGFloat = 24
}

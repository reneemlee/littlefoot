import SwiftUI

enum Theme {
    // Colors - adaptive for light/dark mode
    static let background = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.12, green: 0.11, blue: 0.10, alpha: 1.0)    // #1E1C1A warm dark
            : UIColor(red: 1.0, green: 0.973, blue: 0.941, alpha: 1.0)   // #FFF8F0 warm cream
    })

    static let primary = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.95, green: 0.65, blue: 0.55, alpha: 1.0)    // brighter coral
            : UIColor(red: 0.910, green: 0.588, blue: 0.478, alpha: 1.0) // #E8967A
    })

    static let secondary = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.60, green: 0.76, blue: 0.70, alpha: 1.0)    // brighter sage
            : UIColor(red: 0.537, green: 0.690, blue: 0.627, alpha: 1.0) // #89B0A0
    })

    static let accent = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.98, green: 0.82, blue: 0.52, alpha: 1.0)    // brighter gold
            : UIColor(red: 0.957, green: 0.780, blue: 0.478, alpha: 1.0) // #F4C77A
    })

    static let text = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.95, green: 0.93, blue: 0.90, alpha: 1.0)    // warm white
            : UIColor(red: 0.290, green: 0.247, blue: 0.208, alpha: 1.0) // #4A3F35 dark brown
    })

    static let textLight = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.95, green: 0.93, blue: 0.90, alpha: 0.6)    // warm white 60%
            : UIColor(red: 0.290, green: 0.247, blue: 0.208, alpha: 0.6) // dark brown 60%
    })

    // Card background - slightly elevated from main background in dark mode
    static let cardBackground = Color(uiColor: UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.18, green: 0.16, blue: 0.15, alpha: 1.0)    // elevated dark
            : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)      // white
    })

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

extension View {
    @ViewBuilder
    func doodleStyle(_ colorScheme: ColorScheme) -> some View {
        if colorScheme == .dark {
            self
                .colorInvert()
                .hueRotation(.degrees(180))
        } else {
            self
        }
    }
}

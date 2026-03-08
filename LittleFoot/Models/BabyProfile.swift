import Foundation
import SwiftData

@Model
final class BabyProfile {
    var name: String
    var birthday: Date

    init(name: String, birthday: Date) {
        self.name = name
        self.birthday = birthday
    }

    var dayOfLife: Int {
        let days = Calendar.current.dateComponents([.day], from: birthday, to: Date()).day ?? 0
        return max(1, days + 1)
    }

    var ageDescription: String {
        let components = Calendar.current.dateComponents([.month, .day], from: birthday, to: Date())
        let months = components.month ?? 0
        let days = components.day ?? 0

        if months == 0 {
            return "\(days) day\(days == 1 ? "" : "s") old"
        } else {
            return "\(months) month\(months == 1 ? "" : "s"), \(days) day\(days == 1 ? "" : "s") old"
        }
    }
}

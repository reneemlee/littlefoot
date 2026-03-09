import Foundation
import SwiftData

@Model
final class FavoriteActivity {
    var dayNumber: Int
    var dateAdded: Date

    init(dayNumber: Int, dateAdded: Date = Date()) {
        self.dayNumber = dayNumber
        self.dateAdded = dateAdded
    }
}

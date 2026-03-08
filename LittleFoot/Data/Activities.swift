import Foundation

enum Activities {
    static let daily: [Activity] =
        days001to030 +
        days031to090 +
        days091to180 +
        days181to270 +
        days271to365

    static func forDay(_ dayOfLife: Int) -> Activity {
        let index = max(0, min(dayOfLife - 1, daily.count - 1))
        return daily[index]
    }
}

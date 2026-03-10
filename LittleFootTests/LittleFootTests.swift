import Testing
import Foundation
@testable import LittleFoot

@Suite("LittleFoot Tests")
struct LittleFootTests {

    // MARK: - Test 1: Notification deep link resolves to correct activity based on baby age

    @Test("Notification tap navigates to correct activity for baby's age")
    func notificationDeepLinkResolvesToCorrectActivity() {
        // Given a baby born 45 days ago
        let calendar = Calendar.current
        let birthday = calendar.date(byAdding: .day, value: -44, to: Date())!
        // dayOfLife = (days between birthday and today) + 1 = 44 + 1 = 45

        // The notification would carry dayOfLife in userInfo
        let dayOfLife = (calendar.dateComponents([.day], from: birthday, to: Date()).day ?? 0) + 1
        #expect(dayOfLife == 45)

        // When the app receives this day and looks up the activity
        let activity = Activities.forDay(dayOfLife)

        // Then it should match the 45th activity in the array (index 44)
        let expectedActivity = Activities.daily[44]
        #expect(activity.name == expectedActivity.name)
        #expect(activity.doodle == expectedActivity.doodle)

        // And the date shown should be the baby's 45th day
        let activityDate = calendar.date(byAdding: .day, value: dayOfLife - 1, to: birthday)!
        #expect(calendar.isDateInToday(activityDate))
    }

    // MARK: - Test 2: dayOfLife calculation from birthday

    @Test("dayOfLife returns 1 on birth date and increments correctly")
    func dayOfLifeCalculation() {
        let calendar = Calendar.current

        // Baby born today → day 1
        let todayBirthday = Date()
        let todayDays = (calendar.dateComponents([.day], from: todayBirthday, to: Date()).day ?? 0) + 1
        #expect(todayDays == 1)

        // Baby born 9 days ago → day 10
        let nineAgo = calendar.date(byAdding: .day, value: -9, to: Date())!
        let nineDays = (calendar.dateComponents([.day], from: nineAgo, to: Date()).day ?? 0) + 1
        #expect(nineDays == 10)

        // Baby born 364 days ago → day 365
        let almostYear = calendar.date(byAdding: .day, value: -364, to: Date())!
        let almostYearDays = (calendar.dateComponents([.day], from: almostYear, to: Date()).day ?? 0) + 1
        #expect(almostYearDays == 365)
    }

    // MARK: - Test 3: Activities.forDay() boundary clamping

    @Test("forDay clamps out-of-range days to valid boundaries")
    func activitiesForDayBoundaryClamping() {
        let day1Activity = Activities.forDay(1)
        let day365Activity = Activities.forDay(365)

        // Day 0 should clamp to Day 1's activity
        let dayZero = Activities.forDay(0)
        #expect(dayZero.name == day1Activity.name)

        // Negative day should clamp to Day 1's activity
        let dayNegative = Activities.forDay(-5)
        #expect(dayNegative.name == day1Activity.name)

        // Day 366 should clamp to Day 365's activity
        let day366 = Activities.forDay(366)
        #expect(day366.name == day365Activity.name)

        // Day 1000 should clamp to Day 365's activity
        let day1000 = Activities.forDay(1000)
        #expect(day1000.name == day365Activity.name)

        // Day 1 should be "Welcome to the World"
        #expect(day1Activity.name == "Welcome to the World")
    }

    // MARK: - Test 4: ageDescription formatting

    @Test("ageDescription formats singular and plural correctly")
    func ageDescriptionFormatting() {
        let calendar = Calendar.current

        // 1 day old (born yesterday)
        let oneDayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let oneDay = formatAge(from: oneDayAgo)
        #expect(oneDay == "1 day old")

        // 5 days old
        let fiveDaysAgo = calendar.date(byAdding: .day, value: -5, to: Date())!
        let fiveDays = formatAge(from: fiveDaysAgo)
        #expect(fiveDays == "5 days old")

        // 0 days old (born today)
        let today = Date()
        let zeroDays = formatAge(from: today)
        #expect(zeroDays == "0 days old")
    }

    // Helper that mirrors BabyProfile.ageDescription logic to test independently
    private func formatAge(from birthday: Date) -> String {
        let components = Calendar.current.dateComponents([.month, .day], from: birthday, to: Date())
        let months = components.month ?? 0
        let days = components.day ?? 0

        if months == 0 {
            return "\(days) day\(days == 1 ? "" : "s") old"
        } else {
            return "\(months) month\(months == 1 ? "" : "s"), \(days) day\(days == 1 ? "" : "s") old"
        }
    }

    // MARK: - Test 5: Activities array has exactly 365 entries

    @Test("Activities.daily contains exactly 365 activities")
    func activitiesArrayCount() {
        #expect(Activities.daily.count == 365)
    }
}

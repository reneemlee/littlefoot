import SwiftUI
import SwiftData

struct OnboardingView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var babyName = ""
    @State private var birthday = Date()
    @State private var showDatePicker = false

    private var isFormValid: Bool {
        !babyName.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Header
                VStack(spacing: 12) {
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 24))

                    Text("Little Foot")
                        .font(Theme.largeTitle)
                        .foregroundColor(Theme.text)

                    Text("Track your baby's first year,\none day at a time")
                        .font(Theme.body)
                        .foregroundColor(Theme.textLight)
                        .multilineTextAlignment(.center)
                }

                // Form
                VStack(spacing: 20) {
                    // Name field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Baby's Name")
                            .font(Theme.caption)
                            .foregroundColor(Theme.textLight)
                            .textCase(.uppercase)

                        TextField("Enter name", text: $babyName)
                            .font(Theme.body)
                            .foregroundColor(Theme.text)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(Theme.cornerRadius)
                            .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                    }

                    // Birthday field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Birthday")
                            .font(Theme.caption)
                            .foregroundColor(Theme.textLight)
                            .textCase(.uppercase)

                        DatePicker(
                            "Birthday",
                            selection: $birthday,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .font(Theme.body)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(Theme.cornerRadius)
                        .shadow(color: .black.opacity(0.04), radius: 8, y: 4)
                    }
                }
                .padding(.horizontal, Theme.screenPadding)

                Spacer()

                // Get Started button
                Button(action: createProfile) {
                    Text("Get Started")
                        .font(Theme.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 18)
                        .background(isFormValid ? Theme.primary : Theme.primary.opacity(0.4))
                        .cornerRadius(Theme.cornerRadius)
                        .shadow(color: Theme.primary.opacity(0.3), radius: 12, y: 6)
                }
                .disabled(!isFormValid)
                .padding(.horizontal, Theme.screenPadding)
                .padding(.bottom, 40)
            }
        }
    }

    private func createProfile() {
        let profile = BabyProfile(
            name: babyName.trimmingCharacters(in: .whitespaces),
            birthday: birthday
        )
        modelContext.insert(profile)
        NotificationManager.requestPermission()
    }
}

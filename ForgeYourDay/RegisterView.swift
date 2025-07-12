import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    var onRegister: () -> Void
    var onBack: () -> Void
    @State private var errorMessage = ""
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            // Logo only
            Image("dayForge_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .padding(.bottom, Theme.padding * 1.5)
            // All fields in a single VStack
            VStack(spacing: Theme.padding) {
                HStack(spacing: Theme.smallPadding) {
                    TextField("First Name", text: $firstName)
                        .font(.body)
                        .foregroundColor(.primaryDark)
                        .autocapitalization(.none)
                        .padding(.vertical, 12)
                        .padding(.horizontal, Theme.padding)
                        .background(Color.secondary.opacity(0.08))
                        .cornerRadius(Theme.cornerRadius)
                        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color.secondary.opacity(0.15)))
                    TextField("Last Name", text: $lastName)
                        .font(.body)
                        .foregroundColor(.primaryDark)
                        .autocapitalization(.none)
                        .padding(.vertical, 12)
                        .padding(.horizontal, Theme.padding)
                        .background(Color.secondary.opacity(0.08))
                        .cornerRadius(Theme.cornerRadius)
                        .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color.secondary.opacity(0.15)))
                }
                TextField("Username", text: $username)
                    .font(.body)
                    .foregroundColor(.primaryDark)
                    .autocapitalization(.none)
                    .padding(.vertical, 12)
                    .padding(.horizontal, Theme.padding)
                    .background(Color.secondary.opacity(0.08))
                    .cornerRadius(Theme.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color.secondary.opacity(0.15)))
                SecureField("Password", text: $password)
                    .font(.body)
                    .foregroundColor(.primaryDark)
                    .autocapitalization(.none)
                    .padding(.vertical, 12)
                    .padding(.horizontal, Theme.padding)
                    .background(Color.secondary.opacity(0.08))
                    .cornerRadius(Theme.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color.secondary.opacity(0.15)))
                SecureField("Confirm Password", text: $confirmPassword)
                    .font(.body)
                    .foregroundColor(.primaryDark)
                    .autocapitalization(.none)
                    .padding(.vertical, 12)
                    .padding(.horizontal, Theme.padding)
                    .background(Color.secondary.opacity(0.08))
                    .cornerRadius(Theme.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color.secondary.opacity(0.15)))
            }
            .padding(.horizontal, Theme.padding)
            .padding(.bottom, Theme.padding * 1.5)
            if !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.accent)
                    .padding(.bottom, 8)
            }
            // Register button
            Button(action: handleRegister) {
                Text("Register")
                    .font(.manrope(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.smallPadding * 1.5)
                    .background(Color.accent)
                    .foregroundColor(.primaryLight)
                    .cornerRadius(Theme.cornerRadius)
            }
            .padding(.horizontal, Theme.padding)
            .padding(.top, Theme.padding)
            // Back button
            Button(action: onBack) {
                Text("Back")
                    .font(.inter(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.top, Theme.padding)
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.primaryLight, Color.primaryLight.opacity(0.85)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }

    private func handleRegister() {
        let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Username cannot be empty."
            return
        }
        let defaults = UserDefaults.standard
        var registered = defaults.stringArray(forKey: "registeredUsernames") ?? ["Kimia", "Taenam", "Zay"]
        if registered.contains(trimmed) {
            errorMessage = "Username already taken. Try a different username."
            return
        }
        // Add new username to the list
        registered.append(trimmed)
        defaults.setValue(registered, forKey: "registeredUsernames")
        errorMessage = ""
        onRegister()
    }
}

#Preview {
    RegisterView(onRegister: {}, onBack: {})
} 
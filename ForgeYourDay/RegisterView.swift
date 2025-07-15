import SwiftUI

struct RegisterView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    var onRegister: (String) -> Void
    var onBack: () -> Void
    @State private var errorMessage = ""
    @State private var usernameTaken = false
    @State private var passwordMismatch = false
    @State private var allFieldsFilled = false
    
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
                    .onChange(of: username) { newValue in
                        let trimmed = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
                        let defaults = UserDefaults.standard
                        let registered = defaults.stringArray(forKey: "registeredUsernames") ?? ["Kimia", "Taenam", "Zay"]
                        usernameTaken = !trimmed.isEmpty && registered.contains(trimmed)
                        updateAllFieldsFilled()
                    }
                if usernameTaken {
                    Text("Username already taken. Try a different username.")
                        .font(.caption)
                        .foregroundColor(.accent)
                }
                SecureField("Password", text: $password)
                    .font(.body)
                    .foregroundColor(.primaryDark)
                    .autocapitalization(.none)
                    .padding(.vertical, 12)
                    .padding(.horizontal, Theme.padding)
                    .background(Color.secondary.opacity(0.08))
                    .cornerRadius(Theme.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color.secondary.opacity(0.15)))
                    .onChange(of: password) { _ in updatePasswordMatch() }
                SecureField("Confirm Password", text: $confirmPassword)
                    .font(.body)
                    .foregroundColor(.primaryDark)
                    .autocapitalization(.none)
                    .padding(.vertical, 12)
                    .padding(.horizontal, Theme.padding)
                    .background(Color.secondary.opacity(0.08))
                    .cornerRadius(Theme.cornerRadius)
                    .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color.secondary.opacity(0.15)))
                    .onChange(of: confirmPassword) { _ in updatePasswordMatch() }
                if passwordMismatch {
                    Text("Passwords do not match.")
                        .font(.caption)
                        .foregroundColor(.accent)
                }
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
                    .background((usernameTaken || passwordMismatch || !allFieldsFilled) ? Color.secondary : Color.accent)
                    .foregroundColor(.primaryLight)
                    .cornerRadius(Theme.cornerRadius)
            }
            .padding(.horizontal, Theme.padding)
            .padding(.top, Theme.padding)
            .disabled(usernameTaken || passwordMismatch || !allFieldsFilled)
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

    private func updatePasswordMatch() {
        passwordMismatch = !password.isEmpty && !confirmPassword.isEmpty && password != confirmPassword
        updateAllFieldsFilled()
    }
    private func updateAllFieldsFilled() {
        allFieldsFilled = !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
            !password.isEmpty &&
            !confirmPassword.isEmpty
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
        if password != confirmPassword {
            errorMessage = "Passwords do not match."
            return
        }
        // Add new username to the list
        registered.append(trimmed)
        defaults.setValue(registered, forKey: "registeredUsernames")
        // Save password for this username
        defaults.setValue(password, forKey: "password_\(trimmed)")
        errorMessage = ""
        onRegister(trimmed)
    }
}

#Preview {
    RegisterView(onRegister: { _ in }, onBack: {})
} 
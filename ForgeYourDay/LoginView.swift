import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var showError = false
    var onLogin: () -> Void
    var onRegister: () -> Void
    
    var body: some View {
        VStack(spacing: Theme.padding * 1.5) {
            Spacer()
            // Logo only
            Image("dayForge_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 72, height: 72)
                .padding(.bottom, Theme.padding)
            // Input fields
            VStack(spacing: Theme.smallPadding) {
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
            }
            .padding(.horizontal, Theme.padding)
            // Error message
            if showError {
                Text("Invalid credentials. Please try again.")
                    .font(.caption)
                    .foregroundColor(.accent)
                    .padding(.top, 4)
            }
            // Login button
            Button(action: {
                if username == "taenam356" && password == "123123123" {
                    showError = false
                    onLogin()
                } else {
                    showError = true
                }
            }) {
                Text("Login")
                    .font(.manrope(size: 18, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, Theme.smallPadding * 1.5)
                    .background(Color.accent)
                    .foregroundColor(.primaryLight)
                    .cornerRadius(Theme.cornerRadius)
            }
            .padding(.horizontal, Theme.padding)
            // Register button
            Button(action: onRegister) {
                Text("Don't have an account? Register")
                    .font(.inter(size: 15, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.top, Theme.smallPadding)
            Spacer()
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.primaryLight, Color.primaryLight.opacity(0.85)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
        )
    }
}

#Preview {
    LoginView(onLogin: {}, onRegister: {})
} 
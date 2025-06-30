import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    var onLogin: () -> Void
    var onRegister: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Login")
                .font(.largeTitle)
                .bold()
            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            Button("Login") {
                // Authentication logic placeholder
                onLogin()
            }
            .buttonStyle(.borderedProminent)
            Button("Register") {
                onRegister()
            }
            .padding(.top, 10)
        }
        .padding()
    }
}

#Preview {
    LoginView(onLogin: {}, onRegister: {})
} 
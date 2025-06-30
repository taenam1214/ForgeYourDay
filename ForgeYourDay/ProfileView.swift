import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            Text("User profile will be here.")
                .font(.title)
                .foregroundColor(.primaryDark)
                .padding(Theme.padding)
                .navigationTitle("Profile")
                .background(Color.primaryLight.ignoresSafeArea())
        }
    }
}

#Preview {
    ProfileView()
} 
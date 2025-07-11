import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            Text("Feed will be here.")
                .font(.title)
                .foregroundColor(.primaryDark)
                .padding(Theme.padding)
                .navigationTitle("Home")
                .background(Color.primaryLight.ignoresSafeArea())
        }
    }
}

#Preview {
    HomeView()
} 
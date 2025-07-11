import SwiftUI

struct MainTabView: View {
    let username: String
    let onLogout: () -> Void
    init(username: String, onLogout: @escaping () -> Void) {
        self.username = username
        self.onLogout = onLogout
        UITabBar.appearance().backgroundColor = UIColor(Color.primaryLight)
        UITabBar.appearance().unselectedItemTintColor = UIColor(Color.secondary)
    }
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            AddPostView(username: username)
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add")
                }
            ProfileView(username: username, onLogout: onLogout)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .accentColor(.accent)
    }
}

#Preview {
    MainTabView(username: "taenam356", onLogout: {})
} 
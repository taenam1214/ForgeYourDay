import SwiftUI

struct MainTabView: View {
    let username: String
    init(username: String) {
        self.username = username
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
            AddPostView()
                .tabItem {
                    Image(systemName: "plus.circle")
                    Text("Add")
                }
            ProfileView(username: username)
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .accentColor(.accent)
    }
}

#Preview {
    MainTabView(username: "taenam356")
} 
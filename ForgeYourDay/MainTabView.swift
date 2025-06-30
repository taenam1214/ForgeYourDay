import SwiftUI

struct MainTabView: View {
    init() {
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
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
        .accentColor(.accent)
    }
}

#Preview {
    MainTabView()
} 
import SwiftUI

struct MainTabView: View {
    @Binding var username: String
    let onLogout: () -> Void
    let onUsernameChange: (String) -> Void
    
    @State private var selectedTab: Tab = .home
    
    enum Tab {
        case home, add, profile
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                if selectedTab == .home {
                    HomeView(username: username)
                        .transition(.opacity)
                }
                if selectedTab == .add {
                    AddPostView(username: username)
                        .transition(.opacity)
                }
                if selectedTab == .profile {
                    ProfileView(username: username, onLogout: onLogout, onUsernameChange: onUsernameChange)
                        .transition(.opacity)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut, value: selectedTab)
            
            // Custom Tab Bar
            HStack {
                Spacer()
                tabBarItem(icon: "house", label: "Home", tab: .home)
                Spacer()
                tabBarItem(icon: "plus.circle", label: "Add", tab: .add, accent: true)
                Spacer()
                tabBarItem(icon: "person", label: "Profile", tab: .profile)
                Spacer()
            }
            // .padding(.top, 18)
            // .padding(.bottom, 18)
            .background(Color.primaryLight.ignoresSafeArea(edges: .bottom))
            .shadow(color: Color.black.opacity(0.08), radius: 8, y: -2)
        }
    }
    
    @ViewBuilder
    private func tabBarItem(icon: String, label: String, tab: Tab, accent: Bool = false) -> some View {
        Button(action: { selectedTab = tab }) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 22, weight: .semibold))
                    .foregroundColor(selectedTab == tab ? .accent : .secondary)
                    .padding(.top, 10)
                // Removed text label
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    MainTabView(username: .constant("taenam"), onLogout: {}, onUsernameChange: { _ in })
} 

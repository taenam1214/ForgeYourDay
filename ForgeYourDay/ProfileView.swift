import SwiftUI

struct ProfileView: View {
    @State private var profileImage: Image? = Image(systemName: "person.crop.circle.fill")
    @State private var showingImagePicker = false
    @State private var username: String = "taenam356"
    @State private var tasksCompleted: Int = 42 // Example value
    @State private var motivationalQuote: String = "Stay productive, stay positive!"
    
    var body: some View {
        NavigationView {
            VStack(spacing: Theme.padding * 1.5) {
                Spacer().frame(height: 16)
                // Profile photo and upload button
                ZStack(alignment: .bottomTrailing) {
                    (profileImage ?? Image(systemName: "person.crop.circle.fill"))
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.accent, lineWidth: 3))
                        .shadow(radius: 6)
                    Button(action: { showingImagePicker = true }) {
                        Image(systemName: "camera.fill")
                            .foregroundColor(.primaryLight)
                            .padding(8)
                            .background(Color.accent)
                            .clipShape(Circle())
                            .shadow(radius: 2)
                    }
                    .offset(x: 4, y: 4)
                }
                // Username
                Text(username)
                    .font(.manrope(size: 22, weight: .bold))
                    .foregroundColor(.primaryDark)
                // Motivational quote
                Text(motivationalQuote)
                    .font(.inter(size: 15))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, Theme.padding)
                Divider().padding(.horizontal, Theme.padding)
                // Tasks completed
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                        .foregroundColor(.accent)
                    Text("Tasks completed today:")
                        .font(.body)
                        .foregroundColor(.primaryDark)
                    Text("\(tasksCompleted)")
                        .font(.manrope(size: 18, weight: .bold))
                        .foregroundColor(.accent)
                }
                .padding(.vertical, Theme.smallPadding)
                // Edit Profile button
                Button(action: {
                    // Edit profile action
                }) {
                    Text("Edit Profile")
                        .font(.manrope(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.smallPadding * 1.5)
                        .background(Color.accent)
                        .foregroundColor(.primaryLight)
                        .cornerRadius(Theme.cornerRadius)
                }
                .padding(.horizontal, Theme.padding)
                Spacer()
            }
            .navigationBarItems(trailing:
                Button(action: {
                    // Settings action
                }) {
                    Image(systemName: "gearshape.fill")
                        .foregroundColor(.secondary)
                        .imageScale(.large)
                }
            )
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.primaryLight, Color.primaryLight.opacity(0.85)]), startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .sheet(isPresented: $showingImagePicker) {
                // Placeholder for image picker
                Text("Image Picker goes here")
                    .font(.body)
            }
        }
    }
}

#Preview {
    ProfileView()
} 
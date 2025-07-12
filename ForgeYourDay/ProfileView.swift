import SwiftUI

struct ProfileView: View {
    @State private var profileImage: Image? = Image(systemName: "person.crop.circle.fill")
    @State private var showingImagePicker = false
    @State var username: String
    let onLogout: () -> Void
    @State private var tasksCompleted: Int = 42 // Example value
    @State private var motivationalQuote: String = "Stay productive, stay positive!"
    @State private var editingUsername = false
    @State private var newUsername = ""
    @State private var usernameError = ""
    
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
                ZStack {
                    // Static text (invisible when editing)
                    Text(username)
                        .font(.manrope(size: 22, weight: .bold))
                        .foregroundColor(.primaryDark)
                        .opacity(editingUsername ? 0 : 1)
                    // Editable text field (invisible when not editing)
                    VStack(spacing: 6) {
                        TextField("Username", text: $newUsername)
                            .font(.manrope(size: 22, weight: .bold))
                            .foregroundColor(.primaryDark)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.primaryLight)
                            .cornerRadius(Theme.cornerRadius)
                            .overlay(RoundedRectangle(cornerRadius: Theme.cornerRadius).stroke(Color.accent.opacity(0.2)))
                            .opacity(editingUsername ? 1 : 0)
                        if editingUsername && !usernameError.isEmpty {
                            Text(usernameError)
                                .font(.caption)
                                .foregroundColor(.accent)
                        }
                    }
                }
                .frame(height: 54) // Fixed height to prevent layout shift
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
                // Edit Profile or Save/Cancel buttons
                if editingUsername {
                    HStack(spacing: 16) {
                        Button(action: { saveUsername() }) {
                            Text("Save")
                                .font(.manrope(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(Color.accent)
                                .foregroundColor(.primaryLight)
                                .cornerRadius(Theme.cornerRadius)
                        }
                        Button(action: {
                            editingUsername = false
                            usernameError = ""
                        }) {
                            Text("Cancel")
                                .font(.manrope(size: 16, weight: .regular))
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(Color.secondary.opacity(0.12))
                                .foregroundColor(.secondary)
                                .cornerRadius(Theme.cornerRadius)
                        }
                    }
                    .padding(.horizontal, Theme.padding)
                } else {
                    Button(action: {
                        newUsername = username
                        editingUsername = true
                    }) {
                        Text("Edit Profile")
                            .font(.manrope(size: 16, weight: .semibold))
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(Color.accent)
                            .foregroundColor(.primaryLight)
                            .cornerRadius(Theme.cornerRadius)
                    }
                    .padding(.horizontal, Theme.padding)
                }
                // Logout button
                Button(action: onLogout) {
                    Text("Log Out")
                        .font(.manrope(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, Theme.smallPadding * 1.5)
                        .background(Color.secondary)
                        .foregroundColor(.primaryLight)
                        .cornerRadius(Theme.cornerRadius)
                }
                .padding(.horizontal, Theme.padding)
                .padding(.top, 4)
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
    
    private func saveUsername() {
        let trimmed = newUsername.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            usernameError = "Username cannot be empty."
            return
        }
        let defaults = UserDefaults.standard
        var registered = defaults.stringArray(forKey: "registeredUsernames") ?? ["Kimia", "Taenam", "Zay"]
        // Check if username is already taken (except for current user)
        if registered.contains(trimmed) && trimmed != username {
            usernameError = "Username already taken. Try a different username."
            return
        }
        // Update the registered usernames array
        if let idx = registered.firstIndex(of: username) {
            registered.remove(at: idx)
        }
        registered.append(trimmed)
        defaults.setValue(registered, forKey: "registeredUsernames")
        // Save new username
        username = trimmed
        defaults.setValue(trimmed, forKey: "loggedInUsername")
        usernameError = ""
        editingUsername = false
    }
}

#Preview {
    ProfileView(username: "taenam356", onLogout: {})
} 
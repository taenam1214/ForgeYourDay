import SwiftUI

struct ProfileView: View {
    @State private var profileImage: Image? = Image(systemName: "person.crop.circle.fill")
    @State private var showingImagePicker = false
    @State var username: String
    let onLogout: () -> Void
    let onUsernameChange: (String) -> Void
    @State private var tasksCompleted: Int = 0 // Will be set based on real data
    @State private var motivationalQuote: String = "Stay productive, stay positive!"
    @State private var editingUsername = false
    @State private var newUsername = ""
    @State private var usernameError = ""
    @FocusState private var usernameFieldFocused: Bool
    @State private var showFriendsSheet = false
    @State private var newFriendUsername = ""
    @State private var friends: [String] = []
    @State private var addFriendMessage = ""
    @State private var showLogoutPrompt = false
    
    var body: some View {
        NavigationView {
            ZStack {
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
                        if !editingUsername {
                            Text(username)
                                .font(.manrope(size: 22, weight: .bold))
                                .foregroundColor(.primaryDark)
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                        }
                        if editingUsername {
                            VStack(spacing: 6) {
                                TextField("Username", text: $newUsername)
                                    .font(.manrope(size: 22, weight: .bold))
                                    .foregroundColor(.primaryDark)
                                    .padding(.vertical, 8)
                                    .padding(.horizontal, 16)
                                    .background(Color.primaryLight)
                                    .cornerRadius(Theme.cornerRadius)
                                    .frame(maxWidth: .infinity)
                                    .multilineTextAlignment(.center)
                                    .focused($usernameFieldFocused)
                                if !usernameError.isEmpty {
                                    Text(usernameError)
                                        .font(.caption)
                                        .foregroundColor(.accent)
                                }
                            }
                        }
                    }
                    .frame(height: 54)
                    .onChange(of: editingUsername) { editing in
                        if editing {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                usernameFieldFocused = true
                            }
                        }
                    }
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
                            Button(action: { withAnimation { saveUsername() } }) {
                                Text("Save")
                                    .font(.manrope(size: 16, weight: .semibold))
                                    .frame(maxWidth: .infinity, minHeight: 48)
                                    .background(Color.accent)
                                    .foregroundColor(.primaryLight)
                                    .cornerRadius(Theme.cornerRadius)
                            }
                            Button(action: { withAnimation { editingUsername = false; usernameError = "" } }) {
                                Text("Cancel")
                                    .font(.manrope(size: 16, weight: .regular))
                                    .frame(maxWidth: .infinity, minHeight: 48)
                                    .background(Color.secondary.opacity(0.12))
                                    .foregroundColor(.secondary)
                                    .cornerRadius(Theme.cornerRadius)
                            }
                        }
                        .padding(.horizontal, Theme.padding)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                    } else {
                        Button(action: {
                            withAnimation {
                                newUsername = username
                                editingUsername = true
                            }
                        }) {
                            Text("Edit Profile")
                                .font(.manrope(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(Color.accent)
                                .foregroundColor(.primaryLight)
                                .cornerRadius(Theme.cornerRadius)
                        }
                        .padding(.horizontal, Theme.padding)
                        NavigationLink(destination: FriendView(username: username)) {
                            Text("Friends")
                                .font(.manrope(size: 16, weight: .semibold))
                                .frame(maxWidth: .infinity, minHeight: 48)
                                .background(Color.secondary.opacity(0.12))
                                .foregroundColor(.secondary)
                                .cornerRadius(Theme.cornerRadius)
                        }
                        .padding(.horizontal, Theme.padding)
                    }
                    // Logout button (hide when editing profile)
                    if !editingUsername {
                        Button(action: { withAnimation(.easeOut(duration: 0.3)) { showLogoutPrompt = true } }) {
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
                    }
                    Spacer()
                }
                .onAppear(perform: countTasksCompletedToday)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.primaryLight, Color.primaryLight.opacity(0.85)]), startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                )
                .sheet(isPresented: $showingImagePicker) {
                    // Placeholder for image picker
                    Text("Image Picker goes here")
                        .font(.body)
                }
                // Custom logout confirmation overlay
                if showLogoutPrompt {
                    ZStack {
                        Color.black.opacity(0.25).ignoresSafeArea()
                        VStack(spacing: 20) {
                            Text("Are you sure")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.top, 24)
                            Text("you want to log out?")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.top, -6)
                            HStack(spacing: 24) {
                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.25)) { showLogoutPrompt = false }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                        onLogout()
                                    }
                                }) {
                                    Text("Yes")
                                        .font(.manrope(size: 16, weight: .bold))
                                        .frame(minWidth: 80)
                                        .padding(.vertical, 10)
                                        .background(Color.accent)
                                        .foregroundColor(.primaryLight)
                                        .cornerRadius(Theme.cornerRadius)
                                }
                                Button(action: {
                                    withAnimation(.easeOut(duration: 0.25)) { showLogoutPrompt = false }
                                }) {
                                    Text("No")
                                        .font(.manrope(size: 16, weight: .regular))
                                        .frame(minWidth: 80)
                                        .padding(.vertical, 10)
                                        .background(Color.secondary.opacity(0.12))
                                        .foregroundColor(.secondary)
                                        .cornerRadius(Theme.cornerRadius)
                                }
                            }
                            .padding(.bottom, 16)
                        }
                        .frame(maxWidth: 320)
                        .background(Color.primaryLight)
                        .cornerRadius(Theme.cornerRadius * 2)
                        .shadow(radius: 16, y: 4)
                        .padding(.horizontal, 32)
                        .opacity(showLogoutPrompt ? 1 : 0)
                        .scaleEffect(showLogoutPrompt ? 1 : 0.95)
                        .animation(.easeOut(duration: 0.3), value: showLogoutPrompt)
                    }
                    .transition(.opacity)
                }
            }
        }
    }
    
    // Count the number of tasks completed today by this user
    private func countTasksCompletedToday() {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: "completedTasks"),
              let posts = try? JSONDecoder().decode([AddPostView.CompletedTask].self, from: data) else {
            tasksCompleted = 0
            return
        }
        let today = Date()
        let calendar = Calendar.current
        let count = posts.filter { post in
            post.username == username && calendar.isDate(post.date, inSameDayAs: today)
        }.count
        tasksCompleted = count
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
        let oldUsername = username
        username = trimmed
        defaults.setValue(trimmed, forKey: "loggedInUsername")
        usernameError = ""
        editingUsername = false
        onUsernameChange(trimmed)
        migrateUsername(from: oldUsername, to: trimmed)
        countTasksCompletedToday() // Update count after username change
    }

    // Migrate all references from oldUsername to newUsername
    private func migrateUsername(from oldUsername: String, to newUsername: String) {
        let defaults = UserDefaults.standard
        // 1. Rename friends_<old> to friends_<new>
        let oldFriendsKey = "friends_\(oldUsername)"
        let newFriendsKey = "friends_\(newUsername)"
        // 1. Copy (not just move) friends_<old> to friends_<new> if not already present
        if let friends = defaults.stringArray(forKey: oldFriendsKey) {
            let existing = defaults.stringArray(forKey: newFriendsKey) ?? []
            let merged = Array(Set(friends + existing))
            defaults.setValue(merged, forKey: newFriendsKey)
            print("[DEBUG] After migration, friends for \(newUsername): \(merged)")
        }
        defaults.removeObject(forKey: oldFriendsKey)
        // 2. Rename friendRequests_<old> to friendRequests_<new>
        let oldReqKey = "friendRequests_\(oldUsername)"
        let newReqKey = "friendRequests_\(newUsername)"
        // 2. Copy friendRequests_<old> to friendRequests_<new> if not already present
        if let reqs = defaults.stringArray(forKey: oldReqKey) {
            let existing = defaults.stringArray(forKey: newReqKey) ?? []
            let merged = Array(Set(reqs + existing))
            defaults.setValue(merged, forKey: newReqKey)
        }
        defaults.removeObject(forKey: oldReqKey)
        // 3. Rename dailyTasksArray_<old> and dailyTasksDate_<old>
        let oldTasksKey = "dailyTasksArray_\(oldUsername)"
        let newTasksKey = "dailyTasksArray_\(newUsername)"
        // 3. Copy dailyTasksArray_<old> and dailyTasksDate_<old> to new keys if not already present
        if let tasks = defaults.array(forKey: oldTasksKey) {
            let existing = defaults.array(forKey: newTasksKey) ?? []
            let merged = Array(Set((tasks as! [String]) + (existing as! [String])))
            defaults.setValue(merged, forKey: newTasksKey)
        }
        defaults.removeObject(forKey: oldTasksKey)
        let oldDateKey = "dailyTasksDate_\(oldUsername)"
        let newDateKey = "dailyTasksDate_\(newUsername)"
        if let date = defaults.object(forKey: oldDateKey) {
            if defaults.object(forKey: newDateKey) == nil {
                defaults.setValue(date, forKey: newDateKey)
            }
        }
        defaults.removeObject(forKey: oldDateKey)
        // 4. Update all other users' friends and friendRequests lists
        let registered = defaults.stringArray(forKey: "registeredUsernames") ?? []
        for user in registered where user != oldUsername {
            let fKey = "friends_\(user)"
            if var arr = defaults.stringArray(forKey: fKey) {
                let updated = arr.map { $0 == oldUsername ? newUsername : $0 }
                defaults.setValue(updated, forKey: fKey)
            }
            let rKey = "friendRequests_\(user)"
            if var arr = defaults.stringArray(forKey: rKey) {
                let updated = arr.map { $0 == oldUsername ? newUsername : $0 }
                defaults.setValue(updated, forKey: rKey)
            }
        }
        // 5. Update all posts and comments
        if let data = defaults.data(forKey: "completedTasks"),
           var posts = try? JSONDecoder().decode([AddPostView.CompletedTask].self, from: data) {
            var changed = false
            for i in posts.indices {
                if posts[i].username == oldUsername {
                    posts[i].username = newUsername
                    changed = true
                }
                // Update likes
                if let idx = posts[i].likedBy.firstIndex(of: oldUsername) {
                    posts[i].likedBy[idx] = newUsername
                    changed = true
                }
                // Update comments
                for j in posts[i].comments.indices {
                    if posts[i].comments[j].username == oldUsername {
                        posts[i].comments[j].username = newUsername
                        changed = true
                    }
                }
            }
            if changed, let newData = try? JSONEncoder().encode(posts) {
                defaults.set(newData, forKey: "completedTasks")
            }
        }
        // After migration, reload UI state if needed (e.g., by calling checkTaskStatus or similar)
    }
}

#Preview {
    ProfileView(username: "taenam356", onLogout: {}, onUsernameChange: { _ in })
} 
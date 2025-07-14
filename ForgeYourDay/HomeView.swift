import SwiftUI

// Import CompletedTask model from AddPostView
struct HomeView: View {
    let username: String
    @State private var completedTasks: [AddPostView.CompletedTask] = []
    @State private var likedTaskIDs: Set<UUID> = []
    @State private var commentText: String = ""
    @State private var commentingTaskID: UUID? = nil
    @State private var now = Date()
    
    func loadCompletedTasks() {
        let defaults = UserDefaults.standard
        let friendsKey = "friends_\(username)"
        let friends = defaults.stringArray(forKey: friendsKey) ?? []
        if let data = defaults.data(forKey: "completedTasks"),
           let decoded = try? JSONDecoder().decode([AddPostView.CompletedTask].self, from: data) {
            let now = Date()
            let filtered = decoded.filter { post in
                guard let postDate = Calendar.current.date(byAdding: .hour, value: 24, to: post.date) else { return false }
                let isFriendOrSelf = post.username == username || friends.contains(post.username)
                return now < postDate && isFriendOrSelf
            }
            completedTasks = filtered
        } else {
            completedTasks = []
        }
    }
    
    func likeTask(_ task: AddPostView.CompletedTask) {
        guard let idx = completedTasks.firstIndex(where: { $0.id == task.id }) else { return }
        if likedTaskIDs.contains(task.id) {
            completedTasks[idx].likes -= 1
            likedTaskIDs.remove(task.id)
        } else {
            completedTasks[idx].likes += 1
            likedTaskIDs.insert(task.id)
        }
        saveTasks()
    }
    
    func addComment(to task: AddPostView.CompletedTask, comment: String) {
        guard let idx = completedTasks.firstIndex(where: { $0.id == task.id }) else { return }
        let newComment = AddPostView.Comment(username: username, text: comment)
        completedTasks[idx].comments.append(newComment)
        saveTasks()
    }
    
    func saveTasks() {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(completedTasks) {
            defaults.set(encoded, forKey: "completedTasks")
        }
    }
    
    func clearAllPosts() {
        completedTasks = []
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "completedTasks")
    }
    
    // Helper to format date as relative time
    func relativeTimeString(from date: Date) -> String {
        let seconds = Int(now.timeIntervalSince(date))
        if seconds < 60 {
            return "Just now"
        } else if seconds < 3600 {
            let minutes = seconds / 60
            return "\(minutes) min ago"
        } else {
            let hours = seconds / 3600
            return "\(hours) hr ago"
        }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    if completedTasks.isEmpty {
                        Text("No completed tasks yet.")
                            .font(.title3)
                            .foregroundColor(.secondary)
                            .padding(.top, 48)
                    } else {
                        ForEach(completedTasks) { post in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 10) {
                                    Image(systemName: "person.crop.circle")
                                        .resizable()
                                        .frame(width: 36, height: 36)
                                        .foregroundColor(.accent)
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text(post.username)
                                            .font(.headline)
                                            .foregroundColor(.primaryDark)
                                        Text(post.task.isEmpty ? "No title provided." : post.task)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.accent)
                                    }
                                    Spacer()
                                    Text(relativeTimeString(from: post.date))
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                if let data = post.imageData, let uiImage = UIImage(data: data) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(maxWidth: .infinity, maxHeight: 220)
                                        .clipped()
                                        .cornerRadius(Theme.cornerRadius * 1.5)
                                }
                                // Always show description, with placeholder if empty
                                Text(post.description.isEmpty ? "No description provided." : post.description)
                                    .font(.body)
                                    .foregroundColor(.primaryDark)
                                HStack(spacing: 18) {
                                    Button(action: { likeTask(post) }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: likedTaskIDs.contains(post.id) ? "heart.fill" : "heart")
                                                .foregroundColor(.accent)
                                            Text("\(post.likes)")
                                                .foregroundColor(.primaryDark)
                                        }
                                    }
                                    Button(action: { commentingTaskID = post.id }) {
                                        HStack(spacing: 4) {
                                            Image(systemName: "bubble.right")
                                                .foregroundColor(.secondary)
                                            Text("\(post.comments.count)")
                                                .foregroundColor(.primaryDark)
                                        }
                                    }
                                    Spacer()
                                }
                                // Comments
                                if !post.comments.isEmpty {
                                    VStack(alignment: .leading, spacing: 6) {
                                        Text("Comments")
                                            .font(.caption)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.accent)
                                            .padding(.bottom, 2)
                                        ForEach(post.comments, id: \.self) { comment in
                                            HStack(alignment: .top, spacing: 6) {
                                                Text(comment.username)
                                                    .font(.caption)
                                                    .fontWeight(.semibold)
                                                    .foregroundColor(.accent)
                                                Text(comment.text)
                                                    .font(.caption)
                                                    .foregroundColor(.primaryDark)
                                            }
                                            .padding(8)
                                            .background(Color.secondary.opacity(0.08))
                                            .cornerRadius(8)
                                        }
                                    }
                                    .padding(8)
                                    .background(Color.primaryLight.opacity(0.7))
                                    .cornerRadius(12)
                                }
                                // Add comment field
                                if commentingTaskID == post.id {
                                    HStack(spacing: 8) {
                                        TextField("Add a comment...", text: $commentText)
                                            .padding(10)
                                            .background(Color.white)
                                            .cornerRadius(8)
                                            .font(.body)
                                        Button(action: {
                                            if !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                                addComment(to: post, comment: commentText)
                                                commentText = ""
                                                commentingTaskID = nil
                                            }
                                        }) {
                                            Text("Post")
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding(.vertical, 8)
                                                .padding(.horizontal, 16)
                                                .background(Color.accent)
                                                .cornerRadius(8)
                                        }
                                    }
                                    .padding(8)
                                    .background(Color.secondary.opacity(0.08))
                                    .cornerRadius(12)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                    .animation(.easeInOut, value: commentingTaskID == post.id)
                                }
                            }
                            .padding()
                            .background(Color.primaryLight)
                            .cornerRadius(Theme.cornerRadius * 1.5)
                            .shadow(color: Color.black.opacity(0.07), radius: 6, y: 2)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 24)
            }
            .background(Color.white.ignoresSafeArea())
            .refreshable {
                loadCompletedTasks()
            }
            .navigationTitle("Home")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: loadCompletedTasks) {
                        Image(systemName: "arrow.clockwise")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: clearAllPosts) {
                        Image(systemName: "trash")
                    }
                }
            }
            .onAppear(perform: loadCompletedTasks)
            .onReceive(Timer.publish(every: 60, on: .main, in: .common).autoconnect()) { _ in
                now = Date()
            }
        }
    }
}

#Preview {
    HomeView(username: "Test User")
} 
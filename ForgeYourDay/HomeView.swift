import SwiftUI

// Import CompletedTask model from AddPostView
struct HomeView: View {
    @State private var completedTasks: [AddPostView.CompletedTask] = []
    @State private var likedTaskIDs: Set<UUID> = []
    @State private var commentText: String = ""
    @State private var commentingTaskID: UUID? = nil
    
    func loadCompletedTasks() {
        let defaults = UserDefaults.standard
        if let data = defaults.data(forKey: "completedTasks"),
           let decoded = try? JSONDecoder().decode([AddPostView.CompletedTask].self, from: data) {
            completedTasks = decoded
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
        completedTasks[idx].comments.append(comment)
        saveTasks()
    }
    
    func saveTasks() {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(completedTasks) {
            defaults.set(encoded, forKey: "completedTasks")
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
                                    Text(post.username)
                                        .font(.headline)
                                        .foregroundColor(.primaryDark)
                                    Spacer()
                                    Text(post.date, style: .date)
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
                                Text(post.task)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.accent)
                                if !post.description.isEmpty {
                                    Text(post.description)
                                        .font(.body)
                                        .foregroundColor(.primaryDark)
                                }
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
                                    VStack(alignment: .leading, spacing: 4) {
                                        ForEach(post.comments, id: \ .self) { comment in
                                            Text(comment)
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                                .padding(.vertical, 2)
                                        }
                                    }
                                }
                                // Add comment field
                                if commentingTaskID == post.id {
                                    HStack {
                                        TextField("Add a comment...", text: $commentText)
                                            .textFieldStyle(RoundedBorderTextFieldStyle())
                                        Button("Post") {
                                            if !commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                                addComment(to: post, comment: commentText)
                                                commentText = ""
                                                commentingTaskID = nil
                                            }
                                        }
                                        .font(.body)
                                    }
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
            .background(Color.primaryLight.ignoresSafeArea())
            .navigationTitle("Home")
            .onAppear(perform: loadCompletedTasks)
        }
    }
}

#Preview {
    HomeView()
} 
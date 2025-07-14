import SwiftUI
import PhotosUI

struct AddPostView: View {
    var username: String
    @State private var showTaskModal: Bool = false
    @State private var taskInputs: [String] = Array(repeating: "", count: 3)
    @State private var todaysTasks: [String] = []
    @State private var showAddTaskField: Bool = false
    @State private var newTaskText: String = ""
    @State private var animateModal: Bool = false
    @State private var showTaskDonePrompt: Bool = false
    @State private var selectedTask: String? = nil
    @State private var animateTaskDonePrompt: Bool = false
    @State private var showTaskCompletionSheet: Bool = false
    @State private var completionDescription: String = ""
    @State private var completionImage: Image? = nil
    @State private var completionImageItem: PhotosPickerItem? = nil
    @State private var showMissingFieldsAlert: Bool = false
    
    var taskKey: String { "dailyTasksArray_\(username)" }
    var taskDateKey: String { "dailyTasksDate_\(username)" }
    
    func checkTaskStatus() {
        let defaults = UserDefaults.standard
        if let lastDate = defaults.object(forKey: taskDateKey) as? Date,
           let tasks = defaults.array(forKey: taskKey) as? [String] {
            let now = Date()
            if Calendar.current.isDate(now, inSameDayAs: lastDate) {
                todaysTasks = tasks
                showTaskModal = false
            } else {
                // 24 hours passed, clear tasks and input fields
                defaults.removeObject(forKey: taskKey)
                defaults.removeObject(forKey: taskDateKey)
                showTaskModal = true
                taskInputs = Array(repeating: "", count: 3)
                todaysTasks = []
                newTaskText = ""
                showAddTaskField = false
            }
        } else {
            showTaskModal = true
            taskInputs = Array(repeating: "", count: 3)
            todaysTasks = []
            newTaskText = ""
            showAddTaskField = false
        }
    }
    
    func saveTasks() {
        let filtered = taskInputs.map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
        let defaults = UserDefaults.standard
        defaults.setValue(filtered, forKey: taskKey)
        defaults.setValue(Date(), forKey: taskDateKey)
        todaysTasks = filtered
        showTaskModal = false
    }
    
    func addNewTask() {
        let trimmed = newTaskText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        todaysTasks.append(trimmed)
        let defaults = UserDefaults.standard
        defaults.setValue(todaysTasks, forKey: taskKey)
        defaults.setValue(Date(), forKey: taskDateKey)
        newTaskText = ""
        showAddTaskField = false
    }
    
    struct Comment: Codable, Hashable {
        var username: String
        let text: String
    }

    struct CompletedTask: Codable, Identifiable {
        var id: UUID
        var username: String
        let task: String
        let description: String
        let imageData: Data? // Store image as Data
        let date: Date
        var likedBy: [String]
        var comments: [Comment]
    }

    // Migration helper: convert old posts to new format
    static func migrateOldPostsIfNeeded() {
        let defaults = UserDefaults.standard
        guard let data = defaults.data(forKey: "completedTasks") else { return }
        if let oldPosts = try? JSONDecoder().decode([OldCompletedTask].self, from: data) {
            let migrated = oldPosts.map { old in
                CompletedTask(
                    id: old.id,
                    username: old.username,
                    task: old.task,
                    description: old.description,
                    imageData: old.imageData,
                    date: old.date,
                    likedBy: [], // Can't recover who liked, so start empty
                    comments: old.comments
                )
            }
            if let newData = try? JSONEncoder().encode(migrated) {
                defaults.set(newData, forKey: "completedTasks")
            }
        }
    }

    // Old struct for migration
    private struct OldCompletedTask: Codable, Identifiable {
        var id: UUID
        var username: String
        let task: String
        let description: String
        let imageData: Data?
        let date: Date
        var likes: Int
        var comments: [Comment]
    }
    
    func saveCompletedTask(_ completed: CompletedTask) {
        let defaults = UserDefaults.standard
        var all = (try? JSONDecoder().decode([CompletedTask].self, from: defaults.data(forKey: "completedTasks") ?? Data())) ?? []
        all.insert(completed, at: 0) // newest first
        // print("DEBUG: Saving CompletedTask: task=\(completed.task), description=\(completed.description)")
        if let encoded = try? JSONEncoder().encode(all) {
            defaults.set(encoded, forKey: "completedTasks")
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottomTrailing) {
                VStack(alignment: .leading, spacing: Theme.padding) {
                    if !todaysTasks.isEmpty {
                        Text("Today's Tasks:")
                            .font(.headline)
                            .padding(.top)
                            .padding(.leading)
                        ForEach(todaysTasks, id: \.self) { task in
                            HStack {
                                Text(task)
                                    .font(.body)
                                    .padding(.vertical, 14)
                                    .padding(.horizontal, 16)
                                    .background(Color.primaryLight)
                                    .cornerRadius(Theme.cornerRadius * 1.5)
                                    .shadow(color: Color.black.opacity(0.07), radius: 4, y: 2)
                                    .foregroundColor(.primaryDark)
                                    .onTapGesture {
                                        selectedTask = task
                                        showTaskDonePrompt = true
                                    }
                                Spacer()
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 2)
                        }
                    } else {
                        VStack {
                            Spacer()
                            HStack {
                                Spacer()
                                Text("No tasks set for today.")
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            Spacer()
                        }
                    }
                    Spacer() // Always push content up
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background(Color.white.ignoresSafeArea())
                // Floating Action Button (always anchored)
                if !showAddTaskField && !showTaskModal {
                    Button(action: { showAddTaskField = true }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.accent)
                            .shadow(color: Color.accent.opacity(0.18), radius: 8, y: 4)
                    }
                    .padding(.trailing, 28)
                    .padding(.bottom, 64)
                    .accessibilityLabel("Add another task")
                }
                // Inline add field
                if showAddTaskField {
                    VStack {
                        Spacer()
                        HStack {
                            TextField("New Task", text: $newTaskText)
                                .padding()
                                .background(Color.primaryLight)
                                .cornerRadius(Theme.cornerRadius)
                                .font(.body)
                            Button(action: addNewTask) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accent)
                                    .font(.title2)
                            }
                            Button(action: {
                                newTaskText = ""
                                showAddTaskField = false
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.secondary)
                                    .font(.title2)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 56)
                    }
                }
                // Modal overlay
                if showTaskModal {
                    ZStack {
                        // Blurred, dimmed background
                        Color.black.opacity(0.2)
                            .ignoresSafeArea()
                            .background(.ultraThinMaterial)
                            .transition(.opacity)
                        // Card
                        VStack(spacing: 0) {
                            VStack(spacing: 18) {
                                Text("What will you forge today?")
                .font(.title)
                                    .fontWeight(.bold)
                                    .padding(.top, 28)
                                    .padding(.horizontal, 24)
                                    .multilineTextAlignment(.center)
                                Text("Set your daily tasks. They will disappear after 24 hours.")
                                    .font(.body)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 24)
                                    .multilineTextAlignment(.center)
                                VStack(spacing: 12) {
                                    ForEach(taskInputs.indices, id: \.self) { idx in
                                        TextField("Task #\(idx + 1)", text: $taskInputs[idx])
                                            .padding(.vertical, 14)
                                            .padding(.horizontal, 16)
                                            .background(Color.secondary.opacity(0.08))
                                            .cornerRadius(Theme.cornerRadius)
                                            .font(.body)
                                    }
                                    Button(action: {
                                        taskInputs.append("")
                                    }) {
                                        HStack {
                                            Image(systemName: "plus.circle.fill")
                                                .foregroundColor(.accent)
                                            Text("Add another task")
                                                .font(.body)
                                        }
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                    }
                                    .background(Color.clear)
                                }
                                .padding(.horizontal, 24)
                                Button(action: saveTasks) {
                                    Text("Save Tasks")
                                        .font(.manrope(size: 18, weight: .bold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, Theme.smallPadding * 2)
                                        .background(Color.accent)
                                        .foregroundColor(.primaryLight)
                                        .cornerRadius(Theme.cornerRadius)
                                        .shadow(color: Color.accent.opacity(0.18), radius: 6, y: 2)
                                }
                                .padding(.horizontal, 24)
                                .padding(.bottom, 24)
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(Color.primaryLight)
                                .shadow(color: Color.black.opacity(0.08), radius: 16, y: 4)
                        )
                        .padding(.horizontal, 16)
                        .opacity(animateModal ? 1 : 0)
                        .scaleEffect(animateModal ? 1 : 0.95)
                        .animation(.easeOut(duration: 0.35), value: animateModal)
                    }
                    .onAppear {
                        animateModal = false
                        withAnimation(.easeOut(duration: 0.35)) {
                            animateModal = true
                        }
                    }
                    .onDisappear {
                        animateModal = false
                    }
                }
                // Task done confirmation prompt
                if showTaskDonePrompt, let selectedTask = selectedTask {
                    ZStack {
                        Color.black.opacity(0.25).ignoresSafeArea()
                        VStack(spacing: 20) {
                            Text("Done with this task?")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .multilineTextAlignment(.center)
                                .padding(.top, 16)
                            Text(selectedTask)
                                .font(.body)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                            HStack(spacing: 24) {
                                Button(action: {
                                    // Show the completion sheet
                                    withAnimation(.easeOut(duration: 0.25)) {
                                        animateTaskDonePrompt = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        showTaskDonePrompt = false
                                        showTaskCompletionSheet = true
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
                                    withAnimation(.easeOut(duration: 0.25)) {
                                        animateTaskDonePrompt = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        showTaskDonePrompt = false
                                    }
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
                        .opacity(animateTaskDonePrompt ? 1 : 0)
                        .scaleEffect(animateTaskDonePrompt ? 1 : 0.95)
                        .animation(.easeOut(duration: 0.3), value: animateTaskDonePrompt)
                    }
                    .onAppear {
                        animateTaskDonePrompt = false
                        withAnimation(.easeOut(duration: 0.3)) {
                            animateTaskDonePrompt = true
                        }
                    }
                    .onDisappear {
                        animateTaskDonePrompt = false
                    }
                }
            }
        }
        .sheet(isPresented: $showTaskCompletionSheet) {
            VStack(spacing: 24) {
                Spacer().frame(height: 12)
                Text("Complete Task")
                    .font(.title2)
                    .fontWeight(.bold)
                if let selectedTask = selectedTask {
                    Text(selectedTask)
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 24)
                }
                // Debug output for troubleshooting
                // VStack(alignment: .leading, spacing: 4) {
                //     Text("DEBUG: selectedTask = \(selectedTask ?? "nil")")
                //         .font(.caption)
                //         .foregroundColor(.red)
                //     Text("DEBUG: completionDescription = \(completionDescription)")
                //         .font(.caption)
                //         .foregroundColor(.red)
                // }
                // Image picker
                PhotosPicker(selection: $completionImageItem, matching: .images, photoLibrary: .shared()) {
                    ZStack {
                        RoundedRectangle(cornerRadius: Theme.cornerRadius)
                            .fill(Color.primaryLight)
                            .frame(width: 120, height: 120)
                            .shadow(radius: 4, y: 2)
                        if let image = completionImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
                        } else {
                            Image(systemName: "photo.on.rectangle")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 48, height: 48)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                // Description field
                TextField("Add a short description...", text: $completionDescription)
                    .padding()
                    .background(Color.primaryLight)
                    .cornerRadius(Theme.cornerRadius)
                    .font(.body)
                    .padding(.horizontal, 24)
                if showMissingFieldsAlert {
                    Text("Image and description are both required.")
                        .foregroundColor(.red)
                        .font(.caption)
                }
                // Action buttons
                HStack(spacing: 16) {
                    Button(action: { showTaskCompletionSheet = false }) {
                        Text("Cancel")
                            .font(.manrope(size: 16, weight: .regular))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.secondary.opacity(0.12))
                            .foregroundColor(.secondary)
                            .cornerRadius(Theme.cornerRadius)
                    }
                    Button(action: {
                        if completionImageItem == nil || completionDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                            showMissingFieldsAlert = true
                            return
                        }
                        showMissingFieldsAlert = false
                        // Remove from today's tasks
                        if let selectedTask = selectedTask, let idx = todaysTasks.firstIndex(of: selectedTask) {
                            todaysTasks.remove(at: idx)
                            let defaults = UserDefaults.standard
                            defaults.setValue(todaysTasks, forKey: taskKey)
                        }
                        // Prepare image data
                        let capturedTask = selectedTask ?? ""
                        let capturedDescription = completionDescription
                        var imageData: Data? = nil
                        if let item = completionImageItem {
                            Task {
                                if let data = try? await item.loadTransferable(type: Data.self) {
                                    imageData = data
                                    let completed = CompletedTask(
                                        id: UUID(),
                                        username: username,
                                        task: capturedTask,
                                        description: capturedDescription,
                                        imageData: imageData,
                                        date: Date(),
                                        likedBy: [],
                                        comments: []
                                    )
                                    saveCompletedTask(completed)
                                }
                            }
                        } else {
                            let completed = CompletedTask(
                                id: UUID(),
                                username: username,
                                task: capturedTask,
                                description: capturedDescription,
                                imageData: nil,
                                date: Date(),
                                likedBy: [],
                                comments: []
                            )
                            saveCompletedTask(completed)
                        }
                        // Reset modal state
                        showTaskCompletionSheet = false
                        completionDescription = ""
                        completionImage = nil
                        completionImageItem = nil
                        selectedTask = nil
                    }) {
                        Text("Submit")
                            .font(.manrope(size: 16, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.accent)
                            .foregroundColor(.primaryLight)
                            .cornerRadius(Theme.cornerRadius)
                    }
                    .disabled(completionImageItem == nil || completionDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 24)
                Spacer()
            }
            .presentationDetents([.medium, .large])
        }
        .onChange(of: completionImageItem) { newItem in
            guard let newItem else { return }
            Task {
                if let data = try? await newItem.loadTransferable(type: Data.self),
                   let uiImage = UIImage(data: data) {
                    completionImage = Image(uiImage: uiImage)
                }
            }
        }
    }
}

#Preview() {
    AddPostView(username: "Taenam")
}

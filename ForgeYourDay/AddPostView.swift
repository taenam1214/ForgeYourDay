import SwiftUI

struct AddPostView: View {
    let username: String
    @State private var showTaskModal: Bool = false
    @State private var taskInputs: [String] = Array(repeating: "", count: 3)
    @State private var todaysTasks: [String] = []
    @State private var showAddTaskField: Bool = false
    @State private var newTaskText: String = ""
    @State private var animateModal: Bool = false
    @State private var showTaskDonePrompt: Bool = false
    @State private var selectedTask: String? = nil
    @State private var animateTaskDonePrompt: Bool = false
    
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
                        Text("No tasks set for today.")
                            .foregroundColor(.secondary)
                            .padding()
                    }
                    Spacer()
                }
                .onAppear(perform: checkTaskStatus)
                .background(Color.white.ignoresSafeArea())
                // Floating Action Button
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
                                    // Will handle next step (image/desc) later
                                    withAnimation(.easeOut(duration: 0.25)) {
                                        animateTaskDonePrompt = false
                                    }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        showTaskDonePrompt = false
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
    }
}

#Preview() {
    AddPostView(username: "Taenam")
}

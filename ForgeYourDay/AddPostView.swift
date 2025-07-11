import SwiftUI

struct AddPostView: View {
    let username: String
    @State private var showTaskModal: Bool = false
    @State private var taskInputs: [String] = Array(repeating: "", count: 3)
    @State private var todaysTasks: [String] = []
    @State private var showAddTaskField: Bool = false
    @State private var newTaskText: String = ""
    
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
            VStack(alignment: .leading, spacing: Theme.padding) {
                if !todaysTasks.isEmpty {
                    Text("Today's Tasks:")
                        .font(.headline)
                        .padding(.top)
                    ForEach(todaysTasks.indices, id: \.self) { idx in
                        HStack(alignment: .top) {
                            Text("\(idx + 1).")
                                .font(.caption)
                                .foregroundColor(.accent)
                                .padding(.top, 2)
                            Text(todaysTasks[idx])
                                .font(.body)
                                .padding(8)
                                .background(Color.secondary.opacity(0.08))
                                .cornerRadius(Theme.cornerRadius)
                                .foregroundColor(.primaryDark)
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    if showAddTaskField {
                        HStack {
                            TextField("New Task", text: $newTaskText)
                                .padding()
                                .background(Color.secondary.opacity(0.08))
                                .cornerRadius(Theme.cornerRadius)
                                .font(.body)
                            Button(action: addNewTask) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.accent)
                                    .font(.title2)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        Button(action: { showAddTaskField = true }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(.accent)
                                Text("Add another task")
                                    .font(.body)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 4)
                    }
                } else {
                    Text("No tasks set for today.")
                        .foregroundColor(.secondary)
                        .padding()
                }
                Spacer()
            }
            .onAppear(perform: checkTaskStatus)
            .navigationTitle("Add Post")
            .background(Color.primaryLight.ignoresSafeArea())
            .sheet(isPresented: $showTaskModal) {
                VStack(spacing: 20) {
                    Text("What will you forge today?")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                    Text("Set your daily tasks. They will disappear after 24 hours.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    ForEach(taskInputs.indices, id: \.self) { idx in
                        TextField("Task #\(idx + 1)", text: $taskInputs[idx])
                            .padding()
                            .background(Color.secondary.opacity(0.08))
                            .cornerRadius(Theme.cornerRadius)
                            .font(.body)
                            .padding(.horizontal)
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
                    }
                    .padding(.bottom, 8)
                    Button(action: saveTasks) {
                        Text("Save Tasks")
                            .font(.manrope(size: 18, weight: .bold))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, Theme.smallPadding * 1.5)
                            .background(Color.accent)
                            .foregroundColor(.primaryLight)
                            .cornerRadius(Theme.cornerRadius)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .background(Color.primaryLight.ignoresSafeArea())
            }
        }
    }
}

#Preview {
    AddPostView(username: "taenam356")
} 
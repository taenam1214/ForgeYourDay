import SwiftUI

struct HomeView: View {
    @State private var showTaskModal: Bool = false
    @State private var dailyTasks: String = ""
    @State private var tasksForToday: String? = nil
    let taskKey = "dailyTasks"
    let taskDateKey = "dailyTasksDate"
    
    func checkTaskStatus() {
        let defaults = UserDefaults.standard
        if let lastDate = defaults.object(forKey: taskDateKey) as? Date,
           let tasks = defaults.string(forKey: taskKey) {
            let now = Date()
            if Calendar.current.isDate(now, inSameDayAs: lastDate) {
                tasksForToday = tasks
                showTaskModal = false
            } else {
                // 24 hours passed, clear tasks
                defaults.removeObject(forKey: taskKey)
                defaults.removeObject(forKey: taskDateKey)
                showTaskModal = true
            }
        } else {
            showTaskModal = true
        }
    }
    
    func saveTasks() {
        let defaults = UserDefaults.standard
        defaults.setValue(dailyTasks, forKey: taskKey)
        defaults.setValue(Date(), forKey: taskDateKey)
        tasksForToday = dailyTasks
        showTaskModal = false
    }
    
    var body: some View {
        NavigationView {
            VStack {
                if let tasks = tasksForToday {
                    Text("Today's Tasks:")
                        .font(.headline)
                        .padding(.top)
                    Text(tasks)
                        .font(.body)
                        .padding()
                        .background(Color.secondary.opacity(0.08))
                        .cornerRadius(Theme.cornerRadius)
                        .padding(.horizontal)
                } else {
                    Text("No tasks set for today.")
                        .foregroundColor(.secondary)
                        .padding()
                }
                Spacer()
            }
            .onAppear(perform: checkTaskStatus)
            .navigationTitle("Home")
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
                    TextEditor(text: $dailyTasks)
                        .frame(height: 120)
                        .padding()
                        .background(Color.secondary.opacity(0.08))
                        .cornerRadius(Theme.cornerRadius)
                        .padding(.horizontal)
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
    HomeView()
} 
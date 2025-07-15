//
//  ContentView.swift
//  ForgeYourDay
//
//  Created by 맥북 on 6/30/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var showRegister = false
    @State private var loggedInUsername: String? = nil
    
    // Keys for UserDefaults
    let authKey = "isAuthenticated"
    let usernameKey = "loggedInUsername"
    
    init() {
        // Read persisted auth state and username
        let defaults = UserDefaults.standard
        let savedAuth = defaults.bool(forKey: authKey)
        let savedUsername = defaults.string(forKey: usernameKey)
        _isAuthenticated = State(initialValue: savedAuth && savedUsername != nil)
        _loggedInUsername = State(initialValue: savedUsername)
    }

    var body: some View {
        ZStack {
            Color.primaryLight.ignoresSafeArea()
            ZStack {
                if isAuthenticated, let _ = loggedInUsername {
                    MainTabView(
                        username: Binding(
                            get: { loggedInUsername ?? "" },
                            set: { loggedInUsername = $0 }
                        ),
                        onLogout: {
                            loggedInUsername = nil
                            isAuthenticated = false
                            showRegister = false // Always return to login screen after logout
                            // Clear persisted auth state
                            let defaults = UserDefaults.standard
                            defaults.setValue(false, forKey: authKey)
                            defaults.removeObject(forKey: usernameKey)
                        },
                        onUsernameChange: { newUsername in
                            loggedInUsername = newUsername
                            let defaults = UserDefaults.standard
                            defaults.setValue(newUsername, forKey: usernameKey)
                        }
                    )
                    .transition(.opacity)
                } else {
                    if showRegister {
                        RegisterView(
                            onRegister: { username in
                                loggedInUsername = username
                                isAuthenticated = true
                                let defaults = UserDefaults.standard
                                defaults.setValue(true, forKey: authKey)
                                defaults.setValue(username, forKey: usernameKey)
                            },
                            onBack: { showRegister = false }
                        )
                        .transition(.opacity)
                    } else {
                        LoginView(
                            onLogin: { username in
                                loggedInUsername = username
                                isAuthenticated = true
                                let defaults = UserDefaults.standard
                                defaults.setValue(true, forKey: authKey)
                                defaults.setValue(username, forKey: usernameKey)
                            },
                            onRegister: { showRegister = true }
                        )
                        .transition(.opacity)
                    }
                }
            }
            .animation(.easeInOut, value: showRegister)
        }
    }
}

#Preview {
    ContentView()
}

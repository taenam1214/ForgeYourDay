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

    var body: some View {
        ZStack {
            Color.primaryLight.ignoresSafeArea()
            if isAuthenticated, let username = loggedInUsername {
                MainTabView(username: username, onLogout: {
                    loggedInUsername = nil
                    isAuthenticated = false
                })
            } else {
                if showRegister {
                    RegisterView(
                        onRegister: { isAuthenticated = true },
                        onBack: { showRegister = false }
                    )
                } else {
                    LoginView(
                        onLogin: { username in
                            loggedInUsername = username
                            isAuthenticated = true
                        },
                        onRegister: { showRegister = true }
                    )
                }
            }
        }
    }
}

#Preview {
    ContentView()
}

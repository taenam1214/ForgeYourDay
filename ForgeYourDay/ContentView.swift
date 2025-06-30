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

    var body: some View {
        ZStack {
            Color.primaryLight.ignoresSafeArea()
            if isAuthenticated {
                MainTabView()
            } else {
                if showRegister {
                    RegisterView(
                        onRegister: { isAuthenticated = true },
                        onBack: { showRegister = false }
                    )
                } else {
                    LoginView(
                        onLogin: { isAuthenticated = true },
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

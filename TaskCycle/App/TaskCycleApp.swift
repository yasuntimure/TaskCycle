//
//  TaskCycleApp.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-04.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@main
struct TaskCycleApp: App {

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    @StateObject var loginViewModel = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
                if !loginViewModel.userId.isEmpty {
                    TabView {
                        DailyView(viewModel: DailyViewModel(userId: loginViewModel.userId, list: ))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .tabItem {
                                Label("Daily", systemImage: "calendar")
                                    .foregroundColor(.primary)
                            }
                        ContentView()
                            .tabItem {
                                Label("Notes", systemImage: "note.text")
                                    .foregroundColor(.primary)
                            }
                    }
                } else {
                    LoginView(viewModel: loginViewModel)
                }
            }
                .preferredColorScheme(.light)
        }
    }
}


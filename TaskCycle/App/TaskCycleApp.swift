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

    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.light)

        }
    }
}


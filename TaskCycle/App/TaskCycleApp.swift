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

public class Mock {

    static let userId = "5JK0lwRArPULkWLO6Xf9DPxdo073"

    static let note = NoteModel(id: UUID().uuidString,
                                title: "",
                                description: "",
                                items: [],
                                date: Date().timeIntervalSince1970,
                                noteType: NoteType.empty.rawValue)
}




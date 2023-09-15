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
                                title: "Mock Title",
                                description: "",
                                items: [item, item, item, item],
                                date: Date().weekdayFormat(),
                                noteType: NoteType.empty.rawValue)

    static let item = ToDoItemModel(id: UUID().uuidString,
                                    title: "Mock Item",
                                    description: "Mock Description")

    static let emptyItem = ToDoItemModel(id: UUID().uuidString,
                                         title: "",
                                         description: "")
}




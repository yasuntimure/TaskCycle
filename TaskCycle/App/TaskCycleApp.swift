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

    static let note = NoteModel(title: "Mock Title",
                                description: "Mock Description",
                                items: [item1, item2, item3, item4])

    static let task = TaskModel(title: "Mock Task",
                                description: "Mock Description")

    static let item = ToDoItemModel(title: "Mock Item",
                                    description: "Mock Description")
    static let item1 = ToDoItemModel(title: "Mock Item",
                                    description: "Mock Description")
    static let item2 = ToDoItemModel(title: "Mock Item",
                                    description: "Mock Description")
    static let item3 = ToDoItemModel(title: "Mock Item",
                                    description: "Mock Description")
    static let item4 = ToDoItemModel(title: "Mock Item",
                                    description: "Mock Description")

    static let emptyItem = ToDoItemModel()
}




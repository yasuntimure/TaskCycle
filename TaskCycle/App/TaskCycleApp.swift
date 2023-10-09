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

    static let note = Note(title: "Mock Title",
                                description: "Mock Description")

    static let column = BoardColumn()

    static let item = ToDoItem(title: "Mock Item",
                                    description: "Mock Description")
    static let item1 = ToDoItem(title: "Mock Item",
                                    description: "Mock Description")
    static let item2 = ToDoItem(title: "Mock Item",
                                    description: "Mock Description")
    static let item3 = ToDoItem(title: "Mock Item",
                                    description: "Mock Description")
    static let item4 = ToDoItem(title: "Mock Item",
                                    description: "Mock Description")

    static let emptyItem = ToDoItem()
}




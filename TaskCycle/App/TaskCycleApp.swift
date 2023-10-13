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

    @State private var errorWrapper: ErrorWrapper?

    var body: some Scene {
        WindowGroup {
            MainView()
                .preferredColorScheme(.light)
                .environment (\.showError) { error, message in
                    errorWrapper = ErrorWrapper(error: error, message: message)
                }
                .sheet(item: $errorWrapper) { errorWrapper in
                    Text(errorWrapper.error.localizedDescription)
                }
        }
    }
}

struct ErrorWrapper: Identifiable {
    let id: UUID
    let error: Error
    let message: String

    init(id: UUID = UUID(),
         error: Error,
         message: String = "") {
        self.id = id
        self.error = error
        self.message = message
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




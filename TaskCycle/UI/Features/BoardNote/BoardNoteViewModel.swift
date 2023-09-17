//
//  BoardNoteViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-16.
//

import SwiftUI
import FirebaseFirestore

fileprivate typealias Tasks = [NoteModel]

enum TaskStatus {
    case todo, inprogress, done
}

@MainActor
class BoardNoteViewModel: ObservableObject {

    @Published var note: NoteModel

    @State var isToDoTargeted: Bool = false
    @State var isInProgressTargeted: Bool = false
    @State var isDoneTargeted: Bool = false

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    init(note: NoteModel) {
        self.note = note
    }

    func initialFocusState() -> EmptyNoteFields? {
        if note.title.isEmpty {
            return .title
        }

        if !note.title.isEmpty && note.description.isEmpty {
            return .description
        }

        return nil
    }

    func fetchNote() {
        Task {
            do {
                self.note = try await NotesService.get(note)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func updateNote() {
        Task {
            do {
                try await NotesService.put(note)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func addTemplateNote() {
        let note = NoteModel(title: "Quick Note",
                             description: "Complete your quick to do list!")
        self.note.toDoTasks.append(note)
    }

    func handleDropAction(_ droppedTask: [NoteModel], for status: TaskStatus) -> Bool {
        switch status {
        case .todo:
            for task in droppedTask {
                note.inProgressTasks.removeAll(where: {$0 == task})
                note.doneTasks.removeAll(where: {$0 == task})
            }
            let tasks = note.toDoTasks + droppedTask
            note.toDoTasks = Array(tasks.uniqued())
        case .inprogress:
            for task in droppedTask {
                note.toDoTasks.removeAll(where: {$0 == task})
                note.doneTasks.removeAll(where: {$0 == task})
            }
            let tasks = note.inProgressTasks + droppedTask
            note.inProgressTasks = Array(tasks.uniqued())
        case .done:
            for task in droppedTask {
                note.inProgressTasks.removeAll(where: {$0 == task})
                note.toDoTasks.removeAll(where: {$0 == task})
            }
            let tasks = note.doneTasks + droppedTask
            note.doneTasks = Array(tasks.uniqued())
        }
        return true
    }

}

struct Dummy {
    static let task1 = NoteModel(title: "Task 1", description: "Task1 Discriptopn Task1 Discriptopn Task1 Discriptopn Task1 Discriptopn Task1 Discriptopn")
    static let task2 = NoteModel(title: "Task 2 Title ")
    static let task3 = NoteModel(title: "Task 3")
    static let task4 = NoteModel(title: "Task 4")
}

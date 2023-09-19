//
//  NoteViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-17.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class NoteViewModel: ObservableObject {

    @Published var note: NoteModel

    @Published var isNoteConfVisible: Bool = true

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    var uncompletedNote: Bool {
        (note.title.trimmingCharacters(in: .whitespaces).isEmpty) && (note.description.trimmingCharacters(in: .whitespaces).isEmpty)
    }

    init(note: NoteModel) {
        self.note = note
        self.isNoteConfVisible = (note.type() == nil)
    }

    func initialFocusState() -> NoteTextFields? {
        if note.title.isEmpty {
            return .title
        }

        if !note.title.isEmpty && note.description.isEmpty {
            return .description
        }

        return nil
    }

    func addNewTask(to kanbanColumn: KanbanColumn) {
        var updatedColumns = self.note.kanbanColumns
        for (index, column) in updatedColumns.enumerated() {
            if column.id == kanbanColumn.id {
                let quickNote = NoteModel.quickNote()
                updatedColumns[index].tasks.append(quickNote)
            }
        }
        self.note.kanbanColumns = updatedColumns
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

    func deleteNote() {
        Task {
            do {
                try await NotesService.delete(note)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }
}


// MARK: - To Do List Configurations

extension NoteViewModel {

    func reorder() {
        if note.items.contains(where: { $0.title.isEmpty }) {
            note.items.sort(by: { ($0.title.isEmpty && !$1.title.isEmpty) || (!$0.isDone && $1.isDone) })
        } else {
            note.items.sort(by: { !$0.isDone && $1.isDone })
        }
    }

    func deleteItems(at indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                do {
                    let item = note.items[index]
                    try await NotesService.delete(note, of: item)
                } catch {
                    showAlert = true
                    errorMessage = error.localizedDescription
                }
            }
        }
        note.items.remove(atOffsets: indexSet)
    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        note.items.move(fromOffsets: indexSet, toOffset: newIndex)
    }

    func addNewItem() {
        let item = ToDoItemModel()
        note.items.append(item)
    }

}


// MARK: - Board Note Configurations

extension NoteViewModel {

    func delete(_ kanbanColumn: KanbanColumn) {
        var columns = self.note.kanbanColumns
        columns.removeAll { $0.id == kanbanColumn.id }
        self.note.kanbanColumns = columns
    }

    func addKanbanColumn() {
        var columns = self.note.kanbanColumns
        columns.append(KanbanColumn())
        self.note.kanbanColumns = columns
    }

    func duplicate(_ kanbanColumn: KanbanColumn) {
        let copiedColumn = KanbanColumn(
            title: kanbanColumn.title,
            tasks: kanbanColumn.tasks,
            isTargeted: kanbanColumn.isTargeted
        )

        if let originalIndex = self.note.kanbanColumns.firstIndex(where: { $0.id == kanbanColumn.id }) {
            self.note.kanbanColumns.insert(copiedColumn, at: originalIndex + 1)
        }
    }

    /// Removes the dropped tasks from their source column.
    func removeDroppedTasksFromSource(_ droppedTasks: [NoteModel]) {
        for index in self.note.kanbanColumns.indices {
            self.note.kanbanColumns[index].tasks.removeAll { task in
                droppedTasks.contains(task)
            }
        }
    }

    /// Adds the dropped tasks to the destination column, ensuring there are no duplicates.
    func addDroppedTasksToDestination(_ droppedTasks: [NoteModel], to column: KanbanColumn) {
        if let index = self.note.kanbanColumns.firstIndex(where: { $0.id == column.id }) {
            let updatedTasks = self.note.kanbanColumns[index].tasks + droppedTasks
            self.note.kanbanColumns[index].tasks = Array(updatedTasks.uniqued())
        }
    }
}


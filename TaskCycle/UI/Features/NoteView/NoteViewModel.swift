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

    var uncompletedNote: Bool {
        (title.trimmingCharacters(in: .whitespaces).isEmpty) && (description.trimmingCharacters(in: .whitespaces).isEmpty)
    }

    @Published var isNoteConfVisible: Bool = true
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var id: String
    @Published var title: String
    @Published var description: String
    @Published var items: [ToDoItemModel]
    @Published var date: String
    @Published var emoji: String?
    @Published var noteType: String?
    @Published var kanbanColumns: [KanbanColumn]

    init(_ noteModel: NoteModel)
    {
        self.id = noteModel.id
        self.title = noteModel.title
        self.description = noteModel.description
        self.items = noteModel.items
        self.date = noteModel.date
        self.emoji = noteModel.emoji
        self.noteType = noteModel.noteType
        self.kanbanColumns = noteModel.kanbanColumns

        self.isNoteConfVisible = (noteModel.type() == nil)
    }

    func initialFocusState() -> NoteTextFields? {
        if title.isEmpty {
            return .title
        }

        if !title.isEmpty && description.isEmpty {
            return .description
        }

        return nil
    }

    func type() -> NoteType? {
        if let noteType = noteType {
            return NoteType(rawValue: noteType)
        }
        return nil
    }

    func updateNote() {
        Task {
            do {
                try await NotesService.put(self.model())
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteNote() {
        Task {
            do {
                try await NotesService.delete(self.model())
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
        if items.contains(where: { $0.title.isEmpty }) {
            items.sort(by: { ($0.title.isEmpty && !$1.title.isEmpty) || (!$0.isDone && $1.isDone) })
        } else {
            items.sort(by: { !$0.isDone && $1.isDone })
        }
    }

    func deleteItems(at indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                do {
                    let item = items[index]
                    try await NotesService.delete(self.model(), of: item)
                } catch {
                    showAlert = true
                    errorMessage = error.localizedDescription
                }
            }
        }
        items.remove(atOffsets: indexSet)
    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        items.move(fromOffsets: indexSet, toOffset: newIndex)
    }

    func addNewItem() {
        let item = ToDoItemModel()
        items.append(item)
    }

}


// MARK: - Board Note Configurations

extension NoteViewModel {

    func delete(_ kanbanColumn: KanbanColumn) {
        var columns = kanbanColumns
        columns.removeAll { $0.id == kanbanColumn.id }
        kanbanColumns = columns
    }

    func addKanbanColumn() {
        var columns = kanbanColumns
        columns.append(KanbanColumn())
        kanbanColumns = columns
    }


    func addTask(to kanbanColumn: KanbanColumn) {
        var updatedColumns = kanbanColumns
        for (index, column) in updatedColumns.enumerated() {
            if column.id == kanbanColumn.id {
                let quickNote = NoteModel.quickNote()
                updatedColumns[index].tasks.append(quickNote)
            }
        }
        self.kanbanColumns = updatedColumns
    }


    func duplicate(_ kanbanColumn: KanbanColumn) {
        let copiedColumn = KanbanColumn(
            title: kanbanColumn.title,
            tasks: kanbanColumn.tasks,
            isTargeted: kanbanColumn.isTargeted
        )

        if let originalIndex = self.kanbanColumns.firstIndex(where: { $0.id == kanbanColumn.id }) {
            self.kanbanColumns.insert(copiedColumn, at: originalIndex + 1)
        }
    }

    /// Removes the dropped tasks from their source column.
    func removeDroppedTasksFromSource(_ droppedTasks: [NoteModel]) {
        for index in self.kanbanColumns.indices {
            self.kanbanColumns[index].tasks.removeAll { task in
                droppedTasks.contains(task)
            }
        }
    }

    /// Adds the dropped tasks to the destination column, ensuring there are no duplicates.
    func addDroppedTasksToDestination(_ droppedTasks: [NoteModel], to column: KanbanColumn) {
        if let index = self.kanbanColumns.firstIndex(where: { $0.id == column.id }) {
            let updatedTasks = self.kanbanColumns[index].tasks + droppedTasks
            self.kanbanColumns[index].tasks = Array(updatedTasks.uniqued())
        }
    }
}

extension NoteViewModel {

    private func model() -> NoteModel {
        NoteModel(id: self.id,
                  title: self.title,
                  description: self.description,
                  items: self.items,
                  date: self.date,
                  emoji: self.emoji,
                  noteType: self.noteType,
                  kanbanColumns: self.kanbanColumns)

    }
}


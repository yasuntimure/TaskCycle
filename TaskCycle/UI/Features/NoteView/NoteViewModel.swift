//
//  NoteViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-17.
//

import SwiftUI
import FirebaseFirestore
import Algorithms

@MainActor
class NoteViewModel: ObservableObject {

    @Published var taskIsEditable: Bool

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
    @Published var noteType: NoteType? = nil
    @Published var kanbans: [Kanban]

    let service: NotesServiceProtocol

    init(_ noteModel: NoteModel, service: NotesServiceProtocol = NotesService())
    {
        self.id = noteModel.id
        self.title = noteModel.title
        self.description = noteModel.description
        self.items = noteModel.items
        self.date = noteModel.date
        self.emoji = noteModel.emoji

        // Set Note Type
        if let noteTypeString = noteModel.noteType {
            self.noteType = NoteType(rawValue: noteTypeString)
        } else {
            self.noteType = nil
        }

        self.kanbans = noteModel.kanbanModels.map { Kanban($0) }
        self.isNoteConfVisible = (noteModel.type() == nil)

        self.taskIsEditable = noteModel.title.isEmpty

        self.service = service
    }

    func initialFocusState() -> NoteTextFields? {
        if title.isEmpty {
            return .noteTitle
        }

        if !title.isEmpty && description.isEmpty {
            return .noteDescription
        }

        return nil
    }

    func getNoteType(from string: String?) -> NoteType? {
        if let string = string {
            return NoteType(rawValue: string)
        }
        return nil
    }

    func setNoteType(_ type: NoteType) {
        withAnimation {
            self.noteType = .empty
            self.isNoteConfVisible = false
        }
    }

    func updateNote() {
        Task {
            do {
                try await service.updateNote(self.model())
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteNote() {
        Task {
            do {
                try await service.deleteNote(self.model())
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
                    let note = self.model()
                    let item = items[index]
                    try await service.deleteNoteItem(note, of: item)
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

    func delete(_ kanban: Kanban) {
        var updatedKanbans = kanbans
        updatedKanbans.removeAll { $0.id == kanban.id }
        kanbans = updatedKanbans
    }

    func addKanbanColumn() {
        var updatedKanbans = kanbans
        let kanbanModel = KanbanModel()
        let kanban = Kanban(kanbanModel)
        updatedKanbans.append(kanban)
        kanbans = updatedKanbans
    }


    func addTask(to kanban: Kanban) {
        let updatedKanbans = kanbans
        for (index, kanbanItem) in updatedKanbans.enumerated() {
            if kanbanItem.id == kanban.id {
                updatedKanbans[index].tasks.append(TaskModel())
            }
        }
        self.kanbans = updatedKanbans
    }


    func duplicate(_ kanban: Kanban) {
        let kanbanModel = KanbanModel(title: kanban.title, tasks: kanban.tasks)
        let copiedKanban = Kanban(kanbanModel)

        if let originalIndex = self.kanbans.firstIndex(where: { $0.id == kanban.id }) {
            self.kanbans.insert(copiedKanban, at: originalIndex + 1)
        }
    }

    /// Removes the dropped tasks from their source column.
    func removeDroppedTasks(from kanban: Kanban, droppedTasks: [TaskModel]) {
        var tempKanbans = kanbans
        kanbans.enumerated().forEach { i, item in
            if item.id != kanban.id {
                tempKanbans[i].tasks.removeAll { droppedTasks.contains($0)}
            }
        }
        kanbans = tempKanbans
    }

    /// Adds the dropped tasks to the destination column, ensuring there are no duplicates.
    func addDroppedTasks(to kanban: Kanban, droppedTasks: [TaskModel]) {
        var tempKanbans = kanbans
        kanbans.enumerated().forEach { i, item in
            if item.id == kanban.id {
                let updatedTasks = item.tasks + droppedTasks
                tempKanbans[i].tasks = Array(updatedTasks.uniqued())
            }
        }
        kanbans = tempKanbans
    }
}

extension NoteViewModel {

    func model() -> NoteModel {

        var kanbanColumns: [KanbanModel] = []

        self.kanbans.forEach { kanban in
            let kanbanModel = kanban.model()
            kanbanColumns.append(kanbanModel)
        }

        return NoteModel(id: self.id,
                  title: self.title,
                  description: self.description,
                  items: self.items,
                  date: self.date,
                  emoji: self.emoji,
                  noteType: self.noteType?.rawValue,
                  kanbanColumns: kanbanColumns)

    }
}


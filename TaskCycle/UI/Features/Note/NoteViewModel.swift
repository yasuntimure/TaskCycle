//
//  NoteViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-17.
//

import Foundation
import Algorithms
import FirestoreService

@MainActor
class NoteViewModel: ObservableObject {

    @Published var isNoteConfVisible: Bool = true
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var id: String
    @Published var title: String
    @Published var description: String
    @Published var date: String
    @Published var emoji: String?
    @Published var noteType: NoteType? = nil
    @Published var items: [ToDoItem] = []
    @Published var columns: BoardColumns = []

    @Published var taskIsEditable: Bool = false

    init(_ note: Note) {
        self.id = note.id
        self.title = note.title
        self.description = note.description
        self.date = note.date
        self.emoji = note.emoji

        // Set Note Type
        if let noteTypeString = note.noteType {
            self.noteType = NoteType(rawValue: noteTypeString)
        } else {
            self.noteType = nil
        }

        self.items = note.items
        self.columns = note.columns

        self.isNoteConfVisible = (note.type() == nil)
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
        self.noteType = type
        self.isNoteConfVisible = false
    }

    func updateNote() {
        Task {
            do {
                let endpoint = NotesEndpoint.updateNote(self.model())
                try await FirestoreService.request(endpoint)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func deleteNote() {
        Task {
            do {
                let endpoint = NotesEndpoint.deleteNote(self.model())
                try await FirestoreService.request(endpoint)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }
}

extension NoteViewModel {

    func delete(_ column: BoardColumn) {
        var temp = self.columns
        for (i, item) in temp.enumerated() where item.id == column.id {
            temp.remove(at: i)
        }
        self.columns = temp
    }

    func addNewNote(to column: BoardColumn) {
        var temp = self.columns
        for (i, item) in temp.enumerated() where item.id == column.id {
            temp[i].notes.append(Note())
        }
        self.columns = temp
    }

    func duplicate(_ column: BoardColumn) {
        let copiedKanban = BoardColumn(title: column.title, notes: column.notes)
        var temp = self.columns
        if let originalIndex = temp.firstIndex(where: { $0.id == column.id }) {
            temp.insert(copiedKanban, at: originalIndex + 1)
        }
        self.columns = temp
    }

    /// Removes the dropped tasks from their source column.
    func removeDroppedTask(_ droppedTasks: [Note], column: BoardColumn) {
        guard let droppedTask = droppedTasks.first else { return }
        var temp = self.columns
        temp.enumerated().forEach { i, kanbanItem in
            if kanbanItem.id != column.id {
                temp[i].notes.removeAll(where: { $0.id == droppedTask.id })
            }
        }
        self.columns = temp
    }
}

extension NoteViewModel {

    func model() -> Note {
        return Note(id: self.id,
                    title: self.title,
                    description: self.description,
                    date: self.date,
                    emoji: self.emoji,
                    noteType: self.noteType?.rawValue,
                    items: self.items,
                    columns: self.columns)
    }
}


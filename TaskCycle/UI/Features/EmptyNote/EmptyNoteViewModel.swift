//
//  EmptyNoteViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-21.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class EmptyNoteViewModel: ObservableObject {

    @Published var note: NoteModel

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    var uncompletedNote: Bool {
        note.title.isEmpty && descriptionIsEmpty
    }

    var descriptionIsEmpty: Bool {
        (note.description.trimmingCharacters(in: .whitespaces).isEmpty)
    }

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

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

    var uncompletedNote: Bool {
        (title.trimmingCharacters(in: .whitespaces).isEmpty) && (description.trimmingCharacters(in: .whitespaces).isEmpty)
    }

    @Published var isNoteConfVisible: Bool = true
    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var id: String
    @Published var title: String
    @Published var description: String
    @Published var date: String
    @Published var emoji: String?
    @Published var noteType: NoteType? = nil

    let service: NotesServiceProtocol

    init(_ noteModel: Note, service: NotesServiceProtocol = NotesService()) {
        self.id = noteModel.id
        self.title = noteModel.title
        self.description = noteModel.description
        self.date = noteModel.date
        self.emoji = noteModel.emoji

        // Set Note Type
        if let noteTypeString = noteModel.noteType {
            self.noteType = NoteType(rawValue: noteTypeString)
        } else {
            self.noteType = nil
        }

        self.isNoteConfVisible = (noteModel.type() == nil)

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
            self.noteType = type
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

extension NoteViewModel {

    func model() -> Note {
        return Note(id: self.id,
                         title: self.title,
                         description: self.description,
                         date: self.date,
                         emoji: self.emoji,
                         noteType: self.noteType?.rawValue)
    }
}


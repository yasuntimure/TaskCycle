//
//  NotesViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import SwiftUI
import SwiftKeychainWrapper

@MainActor
class NotesViewModel: ObservableObject {

    @Published var settingsPresented: Bool = false

    @Published var notes: [Note] = []

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    let service: NotesServiceProtocol

    init(service: NotesServiceProtocol = NotesService()) {
        self.service = service
        self.fetchNotes()
    }

    func fetchNotes() {
        executeDBOperation(.fetch)
    }


    func deleteItems(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let note = notes[index]
            executeDBOperation(.delete(note))
        }
        notes.remove(atOffsets: indexSet)
    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        notes.move(fromOffsets: indexSet, toOffset: newIndex)
    }

    func addTemplateNote() {
        let note = Note.quickNote()
        executeDBOperation(.save(note))
        notes.append(note)
    }

    func saveNewNote(completion: @escaping (Note) -> Void) {
        let note = Note()
        executeDBOperation(.save(note))
        completion(note)
    }

    private func executeDBOperation(_ action: NotesServiceActions) {
        Task {
            do {
                switch action {
                case .fetch:
                    self.notes = try await service.getNoteList()
                    if notes.isEmpty {
                        self.addTemplateNote()
                        self.fetchNotes()
                    }
                case .save(let note):
                    try await service.createNote(note)
                case .delete(let note):
                    try await service.deleteNote(note)
                }
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

}

enum NotesServiceActions {
    case fetch
    case save(Note)
    case delete(Note)
}

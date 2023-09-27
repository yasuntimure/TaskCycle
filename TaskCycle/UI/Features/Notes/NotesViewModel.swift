//
//  NotesViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import SwiftUI
import FirebaseFirestore
import SwiftKeychainWrapper


@MainActor
class NotesViewModel: ObservableObject {

    @Published var settingsPresented: Bool = false

    @Published var notes: [NoteModel] = []

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    let service: FirestoreServiceProtocol

    init(service: FirestoreServiceProtocol) {
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
        let note = NoteModel.quickNote()
        executeDBOperation(.save(note))
        notes.append(note)
    }

    func saveNewNote(completion: @escaping (NoteModel) -> Void) {
        let note = NoteModel()
        executeDBOperation(.save(note))
        completion(note)
    }

    private func executeDBOperation(_ action: NotesServiceActions) {
        Task {
            do {
                switch action {
                case .fetch:
                    self.notes = try await service.request(NoteModel.self, endpoint: NotesEndpoint.getNoteList) 
                    if notes.isEmpty {
                        self.addTemplateNote()
                        self.fetchNotes()
                    }
                case .save(let note): break
//                    try await service.request(NoteModel.Type, endpoint: NotesEndpoint.)
                case .delete(let note):
                    try await NotesService.delete(note)
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
    case save(NoteModel)
    case delete(NoteModel)
}

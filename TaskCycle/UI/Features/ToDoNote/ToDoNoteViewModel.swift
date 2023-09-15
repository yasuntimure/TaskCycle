//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-29.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

@MainActor
final class ToDoNoteViewModel: ObservableObject {

    @Published var note: NoteModel

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    var uncompletedNote: Bool {
        note.title.isEmpty && note.items.isEmpty
    }

    init(note: NoteModel) {
        self.note = note
    }

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

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        note.items.move(fromOffsets: indexSet, toOffset: newIndex)
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


    func addNewItem() {
        let item = ToDoItemModel()
        note.items.append(item)
    }

}

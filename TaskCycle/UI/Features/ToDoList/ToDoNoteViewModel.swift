//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-29.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class ToDoNoteViewModel: ObservableObject {

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var userId: String
    @Published var note: NoteModel

    var uncompletedNote: Bool {
        note.title.isEmpty && note.items.isEmpty
    }

    init(userId: String, note: NoteModel) {
        self.userId = userId
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
        note.items.remove(atOffsets: indexSet)
    }

    func deleteNote() {
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("notes")
            .document(note.id)
            .delete { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        note.items.move(fromOffsets: indexSet, toOffset: newIndex)
    }

    func updateNote() {

        var array: [Dictionary] = []

        note.items.forEach { item in
            array.append(item.asDictionary())
        }


        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("notes")
            .document(note.id)
            .updateData(["title": note.title,
                         "items": array]) { [weak self] error in

                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    let noteType = String(describing: self?.note.noteType)
                    print("\(noteType) note title updated")
                }
            }
    }


    func addNewItem() {
        let item = ToDoItemModel()
        note.items.append(item)
    }

}

//
//  EmptyNoteViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-21.
//

import SwiftUI
import FirebaseFirestore

class EmptyNoteViewModel: ObservableObject {

    @Published var userId: String
    @Published var note: NoteModel

    init(userId: String, note: NoteModel) {
        self.userId = userId
        self.note = note
        if note.description.isEmpty {
            self.note.description = EmptyNoteFields.description.rawValue
        }
    }

    func initialFocusState() -> EmptyNoteFields? {
        if note.title.isEmpty {
            return .title
        }

        if !note.title.isEmpty && note.description == EmptyNoteFields.description.rawValue {
            note.description = ""
            return .description
        }

        return nil
    }

    func updateNote() {
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("notes")
            .document(note.id)
            .updateData(["title": note.title,
                         "description": note.description]) { error in

                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Note updated")
                }
            }
    }

}

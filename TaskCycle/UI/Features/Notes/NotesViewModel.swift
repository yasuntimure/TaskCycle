//
//  NotesViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class NotesViewModel: ObservableObject {

    @Published var userId: String
    @Published var settingsPresented: Bool = false

    @Published var notes: [NoteModel] = []

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    init(userId: String) {
        self.userId = userId
        self.fetchNotes()
    }

    func fetchNotes() {
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("notes")
            .getDocuments { [weak self] (querySnapshot, err) in

                if let err = err {

                    print("Error getting documents: \(err)")

                } else {

                    self?.notes.removeAll()

                    guard let documents = querySnapshot?.documents else {
                        print("Documents couldnt casted")
                        return
                    }

                    for document in documents {
                        let result = Result {
                            try document.data(as: NoteModel.self)
                        }
                        switch result {
                        case .success(let note):
                            self?.notes.append(note)
                        case .failure(let error):
                            print("Error decoding item: \(error)")
                        }
                    }

                    if let notes = self?.notes, notes.isEmpty {
                        self?.addTemplateNote()
                        self?.fetchNotes()
                    }
                }
            }
    }

    func deleteItems(at indexSet: IndexSet) {
        indexSet.forEach { index in
            Firestore.firestore()
                .collection("users")
                .document(self.userId)
                .collection("notes")
                .document(notes[index].id)
                .delete { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print("Document successfully removed!")
                    }
                }
        }
        notes.remove(atOffsets: indexSet)
    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        notes.move(fromOffsets: indexSet, toOffset: newIndex)
    }

    func addTemplateNote() {
        let note = NoteModel(id: UUID().uuidString,
                             title: "Quick Note",
                             description: "Complete your quick to do list!",
                             items: [],
                             date: Date().timeIntervalSince1970,
                             noteType: NoteType.empty.rawValue)

        // Save model
        Firestore.firestore()
            .collection("users")
            .document(self.userId)
            .collection("notes")
            .document (note.id)
            .setData(note.asDictionary())
    }

    func saveNewNote(type: NoteType, completion: @escaping (NoteModel) -> Void) {
        let note = NoteModel(id: UUID().uuidString,
                             title: "",
                             description: "",
                             items: [],
                             date: Date().timeIntervalSince1970,
                             noteType: type.rawValue)

        // Save model
        Firestore.firestore()
            .collection("users")
            .document(self.userId)
            .collection("notes")
            .document (note.id)
            .setData(note.asDictionary())

        completion(note)
    }

}

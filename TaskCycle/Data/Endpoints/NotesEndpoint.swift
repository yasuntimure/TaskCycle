//
//  NotesEndpoint.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-26.
//

import FirestoreService

public enum NotesEndpoint: FirestoreEndpoint {

    case getNoteList
    case getNote(Note)
    case createNote(Note)
    case deleteNote(Note)
    case updateNote(Note)

    public var path: FirestoreReference {
        let notesRef = firestore.collection("users").document(userID).collection("notes")
        switch self {
        case .getNoteList, .getNote:
            return notesRef
        case .createNote(let note), .deleteNote(let note), .updateNote(let note):
            return notesRef.document(note.id)
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getNoteList, .getNote:
            return .get
        case .createNote(let note):
            return .post(note)
        case .deleteNote:
            return .delete
        case .updateNote(let note):
            return .put(note)
        }
    }
}

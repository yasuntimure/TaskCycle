//
//  NotesEndpoint.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-26.
//

import FirebaseFirestore
import FirestoreService

public enum NotesEndpoint: FirestoreEndpoint {

    case getNoteList
    case getNote(Note)
    case createNote(Note)
    case deleteNote(Note)
    case updateNote(Note)

    public var path: FirestorePath {
        let notesRef = Firestore.firestore().collection("users").document(userID).collection("notes")
        switch self {
        case .getNoteList, .getNote:
            return .collection(notesRef)
        case .createNote(let note), .deleteNote(let note), .updateNote(let note):
            return .document(notesRef.document(note.id))
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getNoteList, .getNote:
            return .get
        case .createNote:
            return .post
        case .deleteNote:
            return .delete
        case .updateNote:
            return .put
        }
    }

    public var task: FirestoreRequestPayload {
        switch self {
        case .getNoteList, .deleteNote:
            return .requestPlain
        case .createNote(let note), .updateNote(let note), .getNote(let note):
            return .setDocument(note)
        }
    }
}

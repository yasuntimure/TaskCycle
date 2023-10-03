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
    case createNote(NoteModel)
    case deleteNote(NoteModel)
    case deleteNoteItem(note: NoteModel, item: ToDoItemModel)
    case updateNote(NoteModel)

    public var path: FirestorePath {
        let notesRef = Firestore.firestore().collection("users").document(userID).collection("notes")
        switch self {
        case .getNoteList:
            return .collection(notesRef)
        case .createNote(let note), .deleteNote(let note), .updateNote(let note):
            return .document(notesRef.document(note.id))
        case .deleteNoteItem(let note, let item):
            return .document(notesRef.document(note.id).collection("items").document(item.id))
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getNoteList:
            return .get
        case .createNote:
            return .post
        case .deleteNote, .deleteNoteItem:
            return .delete
        case .updateNote:
            return .put
        }
    }

    public var task: FirestoreRequestPayload {
        switch self {
        case .getNoteList:
            return .requestPlain
        case .createNote(let note):
            return .createDocument(note)
        case .deleteNote, .deleteNoteItem:
            return .requestPlain
        case .updateNote(let note):
            return .updateDocument(note)
        }
    }
}

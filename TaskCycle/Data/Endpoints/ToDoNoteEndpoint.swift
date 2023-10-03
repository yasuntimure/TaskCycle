//
//  NoteItemsEndpoint.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import FirestoreService
import FirebaseFirestore

public struct ToDoNoteDTO {
    let noteId: String
    let item: ToDoItemModel
}

public enum ToDoNoteEndpoint: FirestoreEndpoint {

    case getItems(noteId: String)
    case createItem(dto: ToDoNoteDTO)
    case deleteItem(dto: ToDoNoteDTO)
    case updateItem(dto: ToDoNoteDTO)

    public var path: FirestorePath {
        let notesRef = Firestore.firestore().collection("users").document(userID).collection("notes")
        switch self {
        case .getItems(let noteId):
            return .collection(notesRef.document(noteId).collection("items"))
        case .createItem(let dto), .deleteItem(let dto), .updateItem(let dto):
            return .document(notesRef.document(dto.noteId).collection("items").document(dto.item.id))
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getItems:
            return .get
        case .createItem:
            return .post
        case .deleteItem:
            return .delete
        case .updateItem:
            return .put
        }
    }

    public var task: FirestoreRequestPayload {
        switch self {
        case .getItems, .deleteItem:
            return .requestPlain
        case .createItem(let dto), .updateItem(let dto):
            return .setDocument(dto.item)
        }
    }
}

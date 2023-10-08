//
//  BoardNoteEndpoint.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import FirestoreService
import FirebaseFirestore

public struct BoardNoteDTO {
    let noteId: String
    let column: BoardColumn
}

public enum BoardNoteEndpoint: FirestoreEndpoint {

    case getColumns(noteId: String)
    case getColumn(dto: BoardNoteDTO)
    case postColumn(dto: BoardNoteDTO)
    case deleteColumn(dto: BoardNoteDTO)
    case putColumn(dto: BoardNoteDTO)

    public var path: FirestorePath {
        let notesRef = Firestore.firestore().collection("users").document(userID).collection("notes")
        switch self {
        case .getColumns(let noteId):
            return .collection(notesRef.document(noteId).collection("columns"))
        case .postColumn(let dto), .deleteColumn(let dto), .putColumn(let dto), .getColumn(let dto):
            return .document(notesRef.document(dto.noteId).collection("columns").document(dto.column.id))
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getColumns, .getColumn:
            return .get
        case .postColumn:
            return .post
        case .deleteColumn:
            return .delete
        case .putColumn:
            return .put
        }
    }

    public var task: FirestoreRequestPayload {
        switch self {
        case .getColumns, .deleteColumn, .getColumn:
            return .requestPlain
        case .postColumn(let dto), .putColumn(let dto):
            return .setDocument(dto.column)
        }
    }
}


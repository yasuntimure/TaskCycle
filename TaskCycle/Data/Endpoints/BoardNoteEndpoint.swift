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
    let kanban: KanbanModel
}

public enum BoardNoteEndpoint: FirestoreEndpoint {

    case getKanbans(noteId: String)
    case createKanban(dto: BoardNoteDTO)
    case deleteKanban(dto: BoardNoteDTO)
    case updateKanban(dto: BoardNoteDTO)

    public var path: FirestorePath {
        let notesRef = Firestore.firestore().collection("users").document(userID).collection("notes")
        switch self {
        case .getKanbans(let noteId):
            return .collection(notesRef.document(noteId).collection("kanbans"))
        case .createKanban(let dto), .deleteKanban(let dto), .updateKanban(let dto):
            return .document(notesRef.document(dto.noteId).collection("kanbans").document(dto.kanban.id))
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getKanbans:
            return .get
        case .createKanban:
            return .post
        case .deleteKanban:
            return .delete
        case .updateKanban:
            return .put
        }
    }

    public var task: FirestoreRequestPayload {
        switch self {
        case .getKanbans, .deleteKanban:
            return .requestPlain
        case .createKanban(let dto), .updateKanban(let dto):
            return .setDocument(dto.kanban)
        }
    }
}


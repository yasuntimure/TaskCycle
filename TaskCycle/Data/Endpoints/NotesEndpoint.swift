//
//  NotesEndpoint.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-26.
//

import SwiftKeychainWrapper
import FirebaseFirestore

extension FirestoreEndpoint {
    public var userID: String {
        return KeychainWrapper.standard.string(forKey: "userIdKey") ?? ""
    }
}

protocol NotesRepositoryProtocol {
    func getNoteList() async throws -> [NoteModel]
    func createNote(_ note: NoteModel) async throws
}

struct NotesRepository: NotesRepositoryProtocol {

    let service: FirestoreServiceProtocol

    init(service: FirestoreServiceProtocol = FirestoreService()) {
        self.service = service
    }

    func getNoteList() async throws -> [NoteModel] {
        let endpoint = NotesEndpoint.getNoteList
        return try await service.request(NoteModel.self, endpoint: endpoint)
    }

    func createNote(_ note: NoteModel) async throws {
        let endpoint = NotesEndpoint.createNote(note: note)
        let _ = try await service.request(NoteModel.self, endpoint: endpoint)
    }

}

public enum NotesEndpoint: FirestoreEndpoint {

    case getNoteList
    case createNote(note: NoteModel)

    public var path: FirestorePath {
        let db = Firestore.firestore()
        switch self {
        case .getNoteList:
            return .collection(db.collection("users").document(userID).collection("notes"))
        case .createNote(let note):
            return .document(db.collection("users").document(userID).collection("notes").document(note.id))
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getNoteList:
            return .get
        case .createNote:
            return .post
        }
    }

    public var task: FirestoreRequestPayload {
        switch self {
        case .getNoteList:
            return .requestPlain
        case .createNote(let note):
            return .createDocument(note)
        }
    }
}

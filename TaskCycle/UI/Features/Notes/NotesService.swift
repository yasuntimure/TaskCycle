//
//  NotesService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-14.
//

import Firebase
import FirebaseFirestore
import SwiftKeychainWrapper

struct NotesService {

    private static var userId: String {
        return KeychainWrapper.standard.string(forKey: "userIdKey") ?? ""
    }

    static func getNotes() async throws -> [NoteModel] {
        guard let collection = FirestorePath.users(userId)?.notes().collectionReference() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.getArray(of: NoteModel(), from: collection).get()
    }

    static func delete(_ note: NoteModel) async throws {
        guard let document = FirestorePath.users(userId)?.notes(note.id).documentReference() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.delete(document).get()
    }

    static func delete(_ note: NoteModel, of item: ToDoItemModel) async throws {
        guard let document = FirestorePath.users(userId)?.notes(note.id).items(item.id).documentReference() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.delete(document).get()
    }

    static func post(_ note: NoteModel) async throws {
        guard let document = FirestorePath.users(userId)?.notes(note.id).documentReference() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.post(note, to: document).get()
    }

    static func put(_ note: NoteModel) async throws {
        guard let document = FirestorePath.users(userId)?.notes(note.id).documentReference() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.put(note, to: document).get()
    }
}



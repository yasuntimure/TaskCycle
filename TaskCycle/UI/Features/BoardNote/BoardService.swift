//
//  BoardService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-16.
//

import FirebaseFirestore
import FirestoreService
import SwiftKeychainWrapper

struct BoardService {

    let note: NoteModel

    init(note: NoteModel) {
        self.note = note
    }

    private var userId: String {
        return KeychainWrapper.standard.string(forKey: "userIdKey") ?? ""
    }

    func getToDoTasks() async throws -> [NoteModel] {
        guard let collection = FirePath.users(userId)?.notes(note.id).toDoTasks().asCollection() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.getArray(of: NoteModel(), from: collection).get()
    }

    func getInProgressTasks() async throws -> [NoteModel] {
        guard let collection = FirePath.users(userId)?.notes(note.id).inProgressTasks().asCollection() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.getArray(of: NoteModel(), from: collection).get()
    }

    func getDoneTasks() async throws -> [NoteModel] {
        guard let collection = FirePath.users(userId)?.notes(note.id).doneTasks().asCollection() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.getArray(of: NoteModel(), from: collection).get()
    }

    func delete(task: NoteModel) async throws {
        let noteCollection = FirePath.users(userId)?.notes(note.id)
        guard let document = noteCollection?.toDoTasks(task.id).asDocument() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.delete(document).get()
    }

    func post() async throws {
        guard let document = FirePath.users(userId)?.notes(note.id).asDocument() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.post(note, to: document).get()
    }

    func put() async throws {
        guard let document = FirePath.users(userId)?.notes(note.id).asDocument() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.put(note, to: document).get()
    }
}

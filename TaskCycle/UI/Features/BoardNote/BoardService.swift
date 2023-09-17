//
//  BoardService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-16.
//

import Firebase
import FirebaseFirestore
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
        guard let collection = FirestorePath.users(userId)?.notes(note.id).toDoTasks().asCollection() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.getArray(of: NoteModel(), from: collection).get()
    }

    func getInProgressTasks() async throws -> [NoteModel] {
        guard let collection = FirestorePath.users(userId)?.notes(note.id).inProgressTasks().asCollection() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.getArray(of: NoteModel(), from: collection).get()
    }

    func getDoneTasks() async throws -> [NoteModel] {
        guard let collection = FirestorePath.users(userId)?.notes(note.id).doneTasks().asCollection() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.getArray(of: NoteModel(), from: collection).get()
    }

    func delete(task: NoteModel, from status: TaskStatus) async throws {
        let noteCollection = FirestorePath.users(userId)?.notes(note.id)
        switch status {
        case .todo:
            guard let document = noteCollection?.toDoTasks(task.id).asDocument() else {
                throw FirebaseError.invalidPath
            }
            return try await FirebaseService.shared.delete(document).get()
        case .inprogress:
            guard let document = noteCollection?.inProgressTasks(task.id).asDocument() else {
                throw FirebaseError.invalidPath
            }
            return try await FirebaseService.shared.delete(document).get()
        case .done:
            guard let document = noteCollection?.doneTasks(task.id).asDocument() else {
                throw FirebaseError.invalidPath
            }
            return try await FirebaseService.shared.delete(document).get()
        }
    }

    func post() async throws {
        guard let document = FirestorePath.users(userId)?.notes(note.id).asDocument() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.post(note, to: document).get()
    }

    func put() async throws {
        guard let document = FirestorePath.users(userId)?.notes(note.id).asDocument() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.put(note, to: document).get()
    }
}

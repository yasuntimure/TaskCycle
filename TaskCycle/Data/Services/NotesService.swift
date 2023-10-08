//
//  NotesService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import FirestoreService

protocol NotesServiceProtocol {
    func getNoteList() async throws -> [Note]
    func createNote(_ note: Note) async throws
    func updateNote(_ note: Note) async throws
    func deleteNote(_ note: Note) async throws
}

struct NotesService: NotesServiceProtocol {

    let service: FirestoreServiceProtocol

    init(service: FirestoreServiceProtocol = FirestoreService()) {
        self.service = service
    }

    func getNoteList() async throws -> [Note] {
        let endpoint = NotesEndpoint.getNoteList
        return try await service.request(Note.self, endpoint: endpoint)
    }

    func createNote(_ note: Note) async throws {
        let endpoint = NotesEndpoint.createNote(note)
        _ = try await service.request(Note.self, endpoint: endpoint)
    }

    func updateNote(_ note: Note) async throws {
        let endpoint = NotesEndpoint.updateNote(note)
        _ = try await service.request(Note.self, endpoint: endpoint)
    }

    func deleteNote(_ note: Note) async throws {
        let endpoint = NotesEndpoint.deleteNote(note)
        _ = try await service.request(Note.self, endpoint: endpoint)
    }

}

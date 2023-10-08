//
//  BoardNoteService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import FirestoreService

protocol BoardNoteServiceProtocol {
    func getKanbans() async throws -> [BoardColumn]
    func create(_ kanban: BoardColumn) async throws
    func update(_ kanban: BoardColumn) async throws
    func delete(_ kanban: BoardColumn) async throws
}

struct BoardNoteService: BoardNoteServiceProtocol {

    let noteId: String
    let service: FirestoreServiceProtocol

    init(noteId: String,
         service: FirestoreServiceProtocol = FirestoreService()) {
        self.noteId = noteId
        self.service = service
    }

    func getKanbans() async throws -> [BoardColumn] {
        let endpoint = BoardNoteEndpoint.getColumns(noteId: self.noteId)
        return try await service.request(BoardColumn.self, endpoint: endpoint)
    }

    func create(_ kanban: BoardColumn) async throws {
        let dto = BoardNoteDTO(noteId: self.noteId, column: kanban)
        let endpoint = BoardNoteEndpoint.postColumn(dto: dto)
        _ = try await service.request(BoardColumn.self, endpoint: endpoint)
    }

    func update(_ kanban: BoardColumn) async throws {
        let dto = BoardNoteDTO(noteId: self.noteId, column: kanban)
        let endpoint = BoardNoteEndpoint.putColumn(dto: dto)
        _ = try await service.request(BoardColumn.self, endpoint: endpoint)
    }

    func delete(_ kanban: BoardColumn) async throws {
        let dto = BoardNoteDTO(noteId: self.noteId, column: kanban)
        let endpoint = BoardNoteEndpoint.deleteColumn(dto: dto)
        _ = try await service.request(BoardColumn.self, endpoint: endpoint)
    }
}


//
//  BoardNoteService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import FirestoreService

protocol BoardNoteServiceProtocol {
    func getKanbans() async throws -> [KanbanModel]
    func createKanban(_ kanban: KanbanModel) async throws
    func updateKanban(_ kanban: KanbanModel) async throws
    func deleteKanban(_ kanban: KanbanModel) async throws
}

struct BoardNoteService: BoardNoteServiceProtocol {

    let noteId: String
    let service: FirestoreServiceProtocol

    init(noteId: String,
         service: FirestoreServiceProtocol = FirestoreService()) {
        self.noteId = noteId
        self.service = service
    }

    func getKanbans() async throws -> [KanbanModel] {
        let endpoint = BoardNoteEndpoint.getKanbans(noteId: self.noteId)
        return try await service.request(KanbanModel.self, endpoint: endpoint)
    }

    func createKanban(_ kanban: KanbanModel) async throws {
        let dto = BoardNoteDTO(noteId: self.noteId, kanban: kanban)
        let endpoint = BoardNoteEndpoint.createKanban(dto: dto)
        _ = try await service.request(KanbanModel.self, endpoint: endpoint)
    }

    func updateKanban(_ kanban: KanbanModel) async throws {
        let dto = BoardNoteDTO(noteId: self.noteId, kanban: kanban)
        let endpoint = BoardNoteEndpoint.updateKanban(dto: dto)
        _ = try await service.request(KanbanModel.self, endpoint: endpoint)
    }

    func deleteKanban(_ kanban: KanbanModel) async throws {
        let dto = BoardNoteDTO(noteId: self.noteId, kanban: kanban)
        let endpoint = BoardNoteEndpoint.deleteKanban(dto: dto)
        _ = try await service.request(KanbanModel.self, endpoint: endpoint)
    }
}


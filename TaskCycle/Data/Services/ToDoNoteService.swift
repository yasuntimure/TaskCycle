//
//  ItemsService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import FirestoreService

protocol ToDoNoteServiceProtocol {
    func getItems() async throws -> [ToDoItemModel]
    func createItem(_ item: ToDoItemModel) async throws
    func updateItem(_ item: ToDoItemModel) async throws
    func deleteItem(_ item: ToDoItemModel) async throws
}

struct ToDoNoteService: ToDoNoteServiceProtocol {

    let noteId: String
    let service: FirestoreServiceProtocol

    init(noteId: String,
         service: FirestoreServiceProtocol = FirestoreService()) {
        self.noteId = noteId
        self.service = service
    }

    func getItems() async throws -> [ToDoItemModel] {
        let endpoint = ToDoNoteEndpoint.getItems(noteId: self.noteId)
        return try await service.request(ToDoItemModel.self, endpoint: endpoint)
    }

    func createItem(_ item: ToDoItemModel) async throws {
        let dto = ToDoNoteDTO(noteId: self.noteId, item: item)
        let endpoint = ToDoNoteEndpoint.createItem(dto: dto)
        _ = try await service.request(ToDoItemModel.self, endpoint: endpoint)
    }

    func updateItem(_ item: ToDoItemModel) async throws {
        let dto = ToDoNoteDTO(noteId: self.noteId, item: item)
        let endpoint = ToDoNoteEndpoint.updateItem(dto: dto)
        _ = try await service.request(ToDoItemModel.self, endpoint: endpoint)
    }

    func deleteItem(_ item: ToDoItemModel) async throws {
        let dto = ToDoNoteDTO(noteId: self.noteId, item: item)
        let endpoint = ToDoNoteEndpoint.deleteItem(dto: dto)
        _ = try await service.request(ToDoItemModel.self, endpoint: endpoint)
    }
}


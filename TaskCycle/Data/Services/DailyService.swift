//
//  WeekDayService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-12.
//

import FirestoreService

protocol DailyServiceProtocol {
    func getItems(for date: String) async throws -> [ToDoItem]
    func createItem(_ item: ToDoItem) async throws
    func updateItem(_ item: ToDoItem) async throws
    func deleteItem(_ item: ToDoItem) async throws
}

struct DailyService: DailyServiceProtocol {

    let service: FirestoreServiceProtocol

    init(service: FirestoreServiceProtocol = FirestoreService()) {
        self.service = service
    }

    func getItems(for date: String) async throws -> [ToDoItem] {
        let endpoint = DailyEndpoint.getItems(forDate: date)
        return try await service.request(ToDoItem.self, endpoint: endpoint)
    }

    func createItem(_ item: ToDoItem) async throws {
        let endpoint = DailyEndpoint.createItem(item)
        _ = try await service.request(ToDoItem.self, endpoint: endpoint)
    }

    func updateItem(_ item: ToDoItem) async throws {
        let endpoint = DailyEndpoint.updateItem(item)
        _ = try await service.request(ToDoItem.self, endpoint: endpoint)
    }

    func deleteItem(_ item: ToDoItem) async throws {
        let endpoint = DailyEndpoint.deleteItem(item)
        _ = try await service.request(ToDoItem.self, endpoint: endpoint)
    }
}

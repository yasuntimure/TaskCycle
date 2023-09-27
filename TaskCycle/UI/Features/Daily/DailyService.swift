//
//  WeekDayService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-12.
//

import Firebase
import FirebaseFirestore
import SwiftKeychainWrapper

struct DailyService {

    private static var userId: String {
        return KeychainWrapper.standard.string(forKey: "userIdKey") ?? ""
    }

    static func getItems(for date: String) async throws -> [ToDoItemModel] {
        guard let collection = FirePath.users(userId)?.weekDays(date).items().asCollection() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.getArray(of: ToDoItemModel(), from: collection).get()
    }

    static func delete(_ item: ToDoItemModel) async throws {
        guard let document = FirePath.users(userId)?.weekDays(item.date).items(item.id).asDocument() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.delete(document).get()
    }

    static func put(_ item: ToDoItemModel) async throws {
        guard let document = FirePath.users(userId)?.weekDays(item.date).items(item.id).asDocument() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.put(item, to: document).get()
    }

    static func post(_ item: ToDoItemModel) async throws {
        guard let document = FirePath.users(userId)?.weekDays(item.date).items(item.id).asDocument() else {
            throw FirestoreServiceError.invalidPath
        }
        return try await FirebaseService.shared.post(item, to: document).get()
    }
}

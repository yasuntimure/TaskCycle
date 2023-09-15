//
//  WeekDayService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-12.
//

import Firebase
import FirebaseFirestore
import SwiftKeychainWrapper

enum CollectionName: String {
    case users
    case weekdays
    case items
    case notes
}

struct DailyService {

    private static var userId: String {
        return KeychainWrapper.standard.string(forKey: "userIdKey") ?? ""
    }

    static func getItems(for date: String) async throws -> [ToDoItemModel] {
        guard let collection = FirestorePath.users(userId)?.weekDays(date).items().collectionReference() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.getArray(of: ToDoItemModel(), from: collection).get()
    }

    static func delete(_ item: ToDoItemModel) async throws {
        guard let document = FirestorePath.users(userId)?.weekDays(item.date).items(item.id).documentReference() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.delete(document).get()
    }

    static func put(_ item: ToDoItemModel) async throws {
        guard let document = FirestorePath.users(userId)?.weekDays(item.date).items(item.id).documentReference() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.put(item, to: document).get()
    }

    static func post(_ item: ToDoItemModel) async throws {
        guard let document = FirestorePath.users(userId)?.weekDays(item.date).items(item.id).documentReference() else {
            throw FirebaseError.invalidPath
        }
        return try await FirebaseService.shared.post(item, to: document).get()
    }
}

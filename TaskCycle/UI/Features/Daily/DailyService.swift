//
//  WeekDayService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-12.
//

import Firebase
import FirebaseFirestore

struct DailyService {
    static func get(for date: Date, userId: String) async throws -> [ToDoItemModel] {
        let ref = FirestorePath(id: userId)
        let collection = ref.itemsCollectionReference(date: date.weekdayFormat())
        return try await FirebaseService.shared.getArray(of: ToDoItemModel(), from: collection).get()
    }

    static func delete(for item: ToDoItemModel, userId: String) async throws {
        let ref = FirestorePath(id: userId)
        let document = ref.itemsCollectionReference(date: item.date).document(item.id)
        return try await FirebaseService.shared.delete(document).get()
    }

    static func put(item: ToDoItemModel, userId: String) async throws {
        let ref = FirestorePath(id: userId)
        let document = ref.itemsCollectionReference(date: item.date).document(item.id)
        return try await FirebaseService.shared.put(item, to: document).get()
    }

    static func post(item: ToDoItemModel, userId: String) async throws {
        let ref = FirestorePath(id: userId)
        let document = ref.itemsCollectionReference(date: item.date).document(item.id)
        return try await FirebaseService.shared.post(item, to: document).get()
    }
}

fileprivate struct FirestorePath {
    let id: String

    func userDocumentReference() -> DocumentReference {
        return FirebaseService.shared.database
            .collection(Collections.users.rawValue)
            .document(id)
    }

    func weekDayDocumentReference(date: String) -> DocumentReference {
        return userDocumentReference()
            .collection(Collections.weekdays.rawValue)
            .document(date)
    }

    func itemsCollectionReference(date: String) -> CollectionReference {
        return weekDayDocumentReference(date: date)
            .collection(Collections.items.rawValue)
    }
}


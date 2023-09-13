//
//  WeekDayService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-12.
//

import Foundation

struct WeekDayService {
    static func get(for date: Date, userId: String) async throws -> [ToDoItemModel] {
        let query = FirebaseService.shared.database
            .collection(Collections.users.rawValue)
            .document(userId)
            .collection(Collections.weekdays.rawValue)
            .document(date.weekdayFormat())
            .collection(Collections.items.rawValue)

        return try await FirebaseService.shared.getArray(of: ToDoItemModel(), with: query).get()
    }

    static func delete(for item: ToDoItemModel, userId: String) async throws {
        let query = FirebaseService.shared.database
            .collection(Collections.users.rawValue)
            .document(userId)
            .collection(Collections.weekdays.rawValue)
            .document(item.date)
            .collection(Collections.items.rawValue)
            .document(item.id)
        return try await FirebaseService.shared.delete(query).get()
    }

}

//func deleteItems(at indexSet: IndexSet) {
//    indexSet.forEach { index in
//        Firestore.firestore()
//            .collection("users")
//            .document(userId)
//            .collection("weekdays")
//            .document(selectedDay.formatedDate())
//            .collection("items")
//            .document(items[index].id)
//            .delete { err in
//                if let err = err {
//                    print("Error removing document: \(err)")
//                } else {
//                    print("Document successfully removed!")
//                }
//            }
//    }
//    items.remove(atOffsets: indexSet)
//}

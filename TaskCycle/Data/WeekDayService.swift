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
            .document(date.format("MM-dd-yyyy"))
            .collection(Collections.items.rawValue)

        return try await FirebaseService.shared.getArray(of: ToDoItemModel(), with: query).get()
    }
}

//
//  WeekModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-28.
//

import Foundation
import FirebaseFirestoreSwift
import FirestoreService

struct WeekDay: FirestoreIdentifiable {
    var id: String
    var date: Date
    var isSelected: Bool
    var items: [ToDoItemModel]

    init(
        id: String = UUID().uuidString,
        date: Date,
        isSelected: Bool = false,
        items: [ToDoItemModel] = []
    ) {
        self.id = id
        self.date = date
        self.isSelected = isSelected
        self.items = items
    }

    func formatedDate() -> String {
        return date.format("MM-dd-yyyy")
    }
}

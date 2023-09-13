//
//  ToDoListItem.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import Foundation
import FirebaseFirestoreSwift


struct ToDoItemModel: FirebaseIdentifiable {
    var id: String
    var title: String
    var description: String
    var date: String
    var isDone: Bool = false

    init(
        id: String = UUID().uuidString,
        title: String = "",
        description: String = "",
        date: String = Date().weekdayFormat(),
        isDone: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.date = date
        self.isDone = isDone
    }
}


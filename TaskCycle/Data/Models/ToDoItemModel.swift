//
//  ToDoListItem.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import Foundation
import FirebaseFirestoreSwift
import FirestoreService


public struct ToDoItemModel: FirestoreIdentifiable {
    public var id: String
    public var title: String
    public var description: String
    public var date: String
    public var isDone: Bool = false

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


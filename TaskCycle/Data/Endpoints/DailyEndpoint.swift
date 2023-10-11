//
//  DailyEndpoint.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import FirestoreService

public enum DailyEndpoint: FirestoreEndpoint {

    case getItems(forDate: String)
    case createItem(ToDoItem)
    case deleteItem(ToDoItem)
    case updateItem(ToDoItem)

    public var path: FirestoreReference {
        let weekdaysRef = firestore.collection("users").document(userID).collection("weekdays")
        switch self {
        case .getItems(let date):
            return weekdaysRef.document(date).collection("items")
        case .createItem(let item), .deleteItem(let item), .updateItem(let item):
            return weekdaysRef.document(item.date).collection("items").document(item.id)
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getItems:
            return .get
        case .createItem(let item):
            return .post(item)
        case .deleteItem:
            return .delete
        case .updateItem(let item):
            return .put(item)
        }
    }
}

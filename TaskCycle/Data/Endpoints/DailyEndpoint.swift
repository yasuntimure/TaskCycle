//
//  DailyEndpoint.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import FirestoreService
import FirebaseFirestore

public enum DailyEndpoint: FirestoreEndpoint {

    case getItems(forDate: String)
    case createItem(ToDoItem)
    case deleteItem(ToDoItem)
    case updateItem(ToDoItem)

    public var path: FirestorePath {
        let weekdaysRef = Firestore.firestore().collection("users").document(userID).collection("weekdays")
        switch self {
        case .getItems(let date):
            return .collection(weekdaysRef.document(date).collection("items"))
        case .createItem(let item), .deleteItem(let item), .updateItem(let item):
            return .document(weekdaysRef.document(item.date).collection("items").document(item.id))
        }
    }

    public var method: FirestoreMethod {
        switch self {
        case .getItems:
            return .get
        case .createItem:
            return .post
        case .deleteItem:
            return .delete
        case .updateItem:
            return .put
        }
    }

    public var task: FirestoreRequestPayload {
        switch self {
        case .getItems, .deleteItem:
            return .requestPlain
        case .createItem(let item), .updateItem(let item):
            return .setDocument(item)
        }
    }
}

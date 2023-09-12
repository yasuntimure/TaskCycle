//
//  ToDoListItem.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import Foundation
import FirebaseFirestoreSwift

protocol ToDoItemProtocol {
    var id: String { get }
    var title: String { get set }
    var description: String { get set }
    var date: TimeInterval { get set }
    var isDone: Bool { get set }
}

struct ToDoItemModel: ToDoItemProtocol, Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var date: TimeInterval
    var isDone: Bool = false
}


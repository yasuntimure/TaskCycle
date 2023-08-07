//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-28.
//

import Foundation
import FirebaseFirestoreSwift

protocol ToDoListProtocol {
    var id: String { get }
    var title: String { get set }
    var description: String { get set }
    var items: [ToDoListItemModel] { get set }
    var date: TimeInterval { get set }
}

struct ToDoListModel: ToDoListProtocol, Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var items: [ToDoListItemModel]
    var date: TimeInterval
}

class ToDoList: ObservableObject {

    @Published var id: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var items: [ToDoListItemModel] = []
    @Published var date: Date = Date()

    func getStructModel() -> ToDoListModel {
        ToDoListModel(id: UUID().uuidString,
                      title: self.title,
                      description: self.description,
                      items: self.items,
                      date: self.date.timeIntervalSince1970)
    }

    func reset() {
        self.id = ""
        self.title = ""
        self.description = ""
        self.items = []
        self.date = Date()
    }
}


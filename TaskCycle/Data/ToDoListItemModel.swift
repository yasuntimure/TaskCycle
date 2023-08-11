//
//  ToDoListItem.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import Foundation
import FirebaseFirestoreSwift

protocol ToDoListItemProtocol {
    var id: String { get }
    var title: String { get set }
    var description: String { get set }
    var date: TimeInterval { get set }
    var isDone: Bool { get set }
}

struct ToDoListItemModel: ToDoListItemProtocol, Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var date: TimeInterval
    var isDone: Bool = false

    mutating func set(_ status: Bool) {
        isDone = status
    }
}

class ToDoListItem: ObservableObject {

    @Published var id: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var isDone: Bool = false
    @Published var isPresented: Bool = false


    func getStructModel() -> ToDoListItemModel {
        ToDoListItemModel(id: UUID().uuidString,
                          title: self.title,
                          description: self.description,
                          date: self.date.timeIntervalSince1970,
                          isDone: self.isDone)
    }

    func reset() {
        self.id = ""
        self.title = ""
        self.description = ""
        self.date = Date()
        self.isDone = false
    }

    func canSave() -> Bool {
        !title.trimmingCharacters(in: .whitespaces).isEmpty
    }

}

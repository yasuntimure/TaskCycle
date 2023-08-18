//
//  ToDoListModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-28.
//

import Foundation
import FirebaseFirestoreSwift

typealias Week = [WeekDay]

struct WeekDay: Hashable, Codable, Identifiable {
    var id: UUID = .init()
    var date: Date
    var isSelected: Bool = false
    var items: [ToDoListItemModel] = []

    func weekDay() -> String {
        return date.format("MM-dd-yyyy")
    }

}

struct WeekDayJSON: Hashable, Codable, Identifiable {
    var id: String = .init()
    var date: TimeInterval
    var isSelected: Bool = false
    var items: [ToDoListItemModel] = []
}

class WeekDayViewModel: ObservableObject {

    @Published var id: String = ""
    @Published var date: Date = Date()
    @Published var items: [ToDoListItemModel] = []

    func getWeekDay() -> WeekDay {
        WeekDay(date: self.date, items: self.items)
    }

    func reset() {
        self.id = ""
        self.items = []
        self.date = Date()
    }
}


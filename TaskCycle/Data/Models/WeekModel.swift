//
//  WeekModel.swift
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
    var items: [ToDoItemModel] = []

    func formatedDate() -> String {
        return date.format("MM-dd-yyyy")
    }
}

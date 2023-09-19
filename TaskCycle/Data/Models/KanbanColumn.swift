//
//  KanbanModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-18.
//

import SwiftUI
import FirebaseFirestoreSwift
import UniformTypeIdentifiers

struct KanbanColumn: FirebaseIdentifiable {
    var id: String
    var title: String
    var tasks: [NoteModel]
    var isTargeted: Bool

    init(id: String = UUID().uuidString,
         title: String = "",
         tasks: [NoteModel] = [],
         isTargeted: Bool = false) {
        self.id = id
        self.title = title
        self.tasks = tasks
        self.isTargeted = isTargeted
    }
}

//
//  KanbanModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-18.
//

import SwiftUI
import FirebaseFirestoreSwift
import UniformTypeIdentifiers

public struct KanbanModel: FirebaseIdentifiable {
    public var id: String
    public var title: String
    public var tasks: [NoteModel]
    public var isTargeted: Bool

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

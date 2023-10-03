//
//  KanbanModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-18.
//

import SwiftUI
import FirebaseFirestoreSwift
import UniformTypeIdentifiers
import FirestoreService

public struct KanbanModel: FirestoreIdentifiable {
    public var id: String
    public var title: String
    public var tasks: [NoteModel]

    init(id: String = UUID().uuidString,
         title: String = "",
         tasks: [NoteModel] = []) {
        self.id = id
        self.title = title
        self.tasks = tasks
    }
}

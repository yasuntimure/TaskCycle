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

typealias BoardColumns = [BoardColumn]

public struct BoardColumn: FirestoreIdentifiable {
    public var id: String
    public var title: String
    public var tasks: [Note]

    init(id: String = UUID().uuidString,
         title: String = "",
         tasks: [Note] = []) {
        self.id = id
        self.title = title
        self.tasks = tasks
    }
}

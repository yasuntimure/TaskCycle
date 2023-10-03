//
//  KanbanColumnViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-19.
//

import SwiftUI

@MainActor
class Kanban: ObservableObject {

    @Published var id: String
    @Published var title: String
    @Published var tasks: [TaskModel]

    init(_ kanbanModel: KanbanModel) {
        self.id = kanbanModel.id
        self.title = kanbanModel.title
        self.tasks = kanbanModel.tasks
    }

    func model() -> KanbanModel {
        return KanbanModel(id: self.id,
                            title: self.title,
                            tasks: self.tasks)

    }

}




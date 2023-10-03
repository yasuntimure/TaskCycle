//
//  BoardNoteViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import Foundation

@MainActor
class BoardNoteViewModel: ObservableObject {

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var kanbans: [KanbanModel] = []

    let service: BoardNoteServiceProtocol

    init(service: BoardNoteServiceProtocol) {
        self.service = service
        self.fetchKanbans()
    }

}

extension BoardNoteViewModel {

    func fetchKanbans() {
        Task {
            do {
                self.kanbans = try await service.getKanbans()
                if kanbans.isEmpty { addTemplateKanbans() }
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func update(_ kanban: KanbanModel) {
        Task {
            do {
                try await service.updateKanban(kanban)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func create(_ kanban: KanbanModel) {
        Task {
            do {
                try await service.createKanban(kanban)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func addNewColumn() {
        let emptyItem = KanbanModel()
        kanbans.insert(emptyItem, at: 0)
        create(emptyItem)
    }

    func addTemplateKanbans() {
        let kanbanColumns: [KanbanModel] = [KanbanModel(title: "To Do"), KanbanModel(title: "In Progress"), KanbanModel(title: "Done")]
        kanbanColumns.forEach { kanban in
            kanbans.append(kanban)
            create(kanban)
        }
    }

    func deleteTask(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let kanban = self.kanbans[index]
            kanbans.remove(at: index)
            Task {
                do {
                    try await service.deleteKanban(kanban)
                } catch {
                    showAlert = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

}

// MARK: - Board Note Configurations

extension BoardNoteViewModel {

    func delete(_ kanban: KanbanModel) {
        kanbans.removeAll { $0.id == kanban.id }
    }

    func addKanbanColumn() {
        let kanban = KanbanModel()
        kanbans.append(kanban)
    }

    func addTask(to kanban: KanbanModel) {
        for (index, kanbanItem) in kanbans.enumerated() {
            if kanbanItem.id == kanban.id {
                kanbans[index].tasks.append(TaskModel())
            }
        }
    }

    func duplicate(_ kanban: KanbanModel) {
        let copiedKanban = KanbanModel(title: kanban.title, tasks: kanban.tasks)
        if let originalIndex = self.kanbans.firstIndex(where: { $0.id == kanban.id }) {
            self.kanbans.insert(copiedKanban, at: originalIndex + 1)
        }
    }

    /// Removes the dropped tasks from their source column.
    func removeDroppedTasks(from kanban: KanbanModel, droppedTasks: [TaskModel]) {
        kanbans.enumerated().forEach { i, item in
            if item.id != kanban.id {
                kanbans[i].tasks.removeAll { droppedTasks.contains($0)}
            }
        }
    }

    /// Adds the dropped tasks to the destination column, ensuring there are no duplicates.
    func addDroppedTasks(to kanban: KanbanModel, droppedTasks: [TaskModel]) {
        kanbans.enumerated().forEach { i, item in
            if item.id == kanban.id {
                let updatedTasks = item.tasks + droppedTasks
                kanbans[i].tasks = Array(updatedTasks.uniqued())
            }
        }
    }
}


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
    }
}

extension BoardNoteViewModel {

    func fetchKanbans() {
        Task {
            do {
                let kanbans = try await service.getKanbans()
                if kanbans.isEmpty {
                    self.addTemplateColumns()
                }
                self.kanbans = kanbans
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func update(_ kanban: KanbanModel) {
        Task {
            do {
                try await service.update(kanban)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func create(_ kanban: KanbanModel) {
        Task {
            do {
                try await service.create(kanban)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func addNewColumn() {
        let newColumn = KanbanModel()
        kanbans.append(newColumn)
        create(newColumn)
    }

    func addTemplateColumns() {
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
                    try await service.delete(kanban)
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

    func addTask(to kanban: KanbanModel) {
        for (index, kanbanItem) in kanbans.enumerated() {
            if kanbanItem.id == kanban.id {
                kanbans[index].tasks.append(NoteModel())
            }
        }
        update(kanban)
    }

    func duplicate(_ kanban: KanbanModel) {
        let copiedKanban = KanbanModel(title: kanban.title, tasks: kanban.tasks)
        if let originalIndex = self.kanbans.firstIndex(where: { $0.id == kanban.id }) {
            self.kanbans.insert(copiedKanban, at: originalIndex + 1)
        }
        self.create(copiedKanban)
    }

    /// Removes the dropped tasks from their source column.
    func removeDroppedTask(_ droppedTasks: [NoteModel], kanban: KanbanModel) {
        guard let droppedTask = droppedTasks.first else { return }
        kanbans.enumerated().forEach { i, kanbanItem in
            if kanbanItem.id != kanban.id {
                kanbans[i].tasks.removeAll(where: { $0.id == droppedTask.id })
                update(kanbans[i])
            }
        }
    }

}


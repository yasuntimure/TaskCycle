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

    @Published var columns: BoardColumns = []

    let service: BoardNoteServiceProtocol

    init(service: BoardNoteServiceProtocol) {
        self.service = service
    }
}

extension BoardNoteViewModel {

    func fetchColumns() {
        Task {
            do {
                let kanbans = try await service.getKanbans()
                if kanbans.isEmpty {
                    self.addTemplateColumns()
                }
                self.columns = kanbans
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func update(_ column: BoardColumn) {
        Task {
            do {
                try await service.update(column)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func create(_ column: BoardColumn) {
        Task {
            do {
                try await service.create(column)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func addNewColumn() {
        let newColumn = BoardColumn()
        columns.append(newColumn)
        create(newColumn)
    }

    func addTemplateColumns() {
        let kanbanColumns: [BoardColumn] = [BoardColumn(title: "To Do"), BoardColumn(title: "In Progress"), BoardColumn(title: "Done")]
        kanbanColumns.forEach { column in
            columns.append(column)
            create(column)
        }
    }

    func deleteTask(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let kanban = self.columns[index]
            columns.remove(at: index)
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

    func delete(_ kanban: BoardColumn) {
        columns.removeAll { $0.id == kanban.id }
    }

    func addTask(to kanban: BoardColumn) {
        for (index, kanbanItem) in columns.enumerated() {
            if kanbanItem.id == kanban.id {
                columns[index].tasks.append(Note())
            }
        }
        update(kanban)
    }

    func duplicate(_ kanban: BoardColumn) {
        let copiedKanban = BoardColumn(title: kanban.title, tasks: kanban.tasks)
        if let originalIndex = self.columns.firstIndex(where: { $0.id == kanban.id }) {
            self.columns.insert(copiedKanban, at: originalIndex + 1)
        }
        self.create(copiedKanban)
    }

    /// Removes the dropped tasks from their source column.
    func removeDroppedTask(_ droppedTasks: [Note], kanban: BoardColumn) {
        guard let droppedTask = droppedTasks.first else { return }
        columns.enumerated().forEach { i, kanbanItem in
            if kanbanItem.id != kanban.id {
                columns[i].tasks.removeAll(where: { $0.id == droppedTask.id })
                update(columns[i])
            }
        }
    }

}


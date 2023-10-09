//
//  BoardNoteViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import Foundation
import SwiftUI

@MainActor
class BoardNoteViewModel: ObservableObject {

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var columns: BoardColumns = []

    func getGrids() -> [GridItem] {
        var grids: [GridItem] = []
        columns.forEach { _ in
            grids.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        }
        grids.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        return grids
    }
}

extension BoardNoteViewModel {

    func addNewColumn() {
        let newColumn = BoardColumn()
        columns.append(newColumn)
    }

}

// MARK: - Board Note Configurations

extension BoardNoteViewModel {

    func delete(_ column: BoardColumn) {
        columns.removeAll { $0.id == column.id }
    }

    func addTask(to column: BoardColumn) {
        for (index, kanbanItem) in columns.enumerated() {
            if kanbanItem.id == column.id {
                columns[index].notes.append(Note())
            }
        }

    }

    func duplicate(_ column: BoardColumn) {
        let copiedKanban = BoardColumn(title: column.title, notes: column.notes)
        if let originalIndex = self.columns.firstIndex(where: { $0.id == column.id }) {
            self.columns.insert(copiedKanban, at: originalIndex + 1)
        }
    }

    /// Removes the dropped tasks from their source column.
    func removeDroppedTask(_ droppedTasks: [Note], kanban: BoardColumn) {
        guard let droppedTask = droppedTasks.first else { return }
        columns.enumerated().forEach { i, kanbanItem in
            if kanbanItem.id != kanban.id {
                columns[i].notes.removeAll(where: { $0.id == droppedTask.id })
            }
        }
    }

}


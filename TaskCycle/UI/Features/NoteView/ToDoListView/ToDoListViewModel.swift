//
//  ToDoListViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import Foundation

@MainActor
class ToDoListViewModel: ObservableObject {

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var items: [ToDoItemModel] = []

    let service: ToDoNoteServiceProtocol

    init(service: ToDoNoteServiceProtocol) {
        self.service = service
        self.fetchItems()
    }
}

extension ToDoListViewModel {

    func fetchItems() {
        Task {
            do {
                self.items = try await service.getItems()
                if items.isEmpty { addNewItem() }
                sortItems()
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func update(_ item: ToDoItemModel) {
        Task {
            do {
                try await service.updateItem(item)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
        sortItems()
    }

    func create(_ item: ToDoItemModel) {
        Task {
            do {
                try await service.createItem(item)
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func addNewItem() {
        let emptyItem = ToDoItemModel()
        items.insert(emptyItem, at: 0)
        create(emptyItem)
    }

    func deleteItems(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let item = self.items[index]
            items.remove(at: index)
            Task {
                do {
                    try await service.deleteItem(item)
                } catch {
                    showAlert = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        items.move(fromOffsets: indexSet, toOffset: newIndex)
    }

    private func sortItems() {
        if items.contains(where: { $0.title.isEmpty }) {
            items.sort(by: { ($0.title.isEmpty && !$1.title.isEmpty) || (!$0.isDone && $1.isDone) })
        } else {
            items.sort(by: { !$0.isDone && $1.isDone })
        }
    }
}

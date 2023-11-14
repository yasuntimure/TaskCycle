//
//  DailyViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-09.
//

import SwiftUI
import FirestoreService

@MainActor
final class DailyViewModel: ObservableObject {

    /// Week Slider Properties
    @Published var selectedDay: WeekDay
    @Published var weekIndex: Int = 1
    @Published var weeks: [[WeekDay]] = []
    @Published var createWeek: Bool = false

    /// To Do List Properties
    @Published var items: [ToDoItem] = []

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    init() {
        selectedDay = WeekDay(date: Date())
    }
}

// MARK: - Week Slider Methods

extension DailyViewModel {

    func setWeekData() {
        if weeks.isEmpty {
            let currentWeek = Date().fetchWeek()

            if let firstDate = currentWeek.first?.date {
                weeks.append(firstDate.createPreviousWeek())
            }

            weeks.append(currentWeek)

            if let lastDate = currentWeek.last?.date {
                weeks.append(lastDate.createNextWeek())
            }
        }
    }

    func paginateWeek() {
        /// SafeCheck
        if weeks.indices.contains(weekIndex) {
            if let firstDate = weeks[weekIndex].first?.date, weekIndex == 0 {
                /// Inserting New Week at 0th Index and Removing Last Array Item
                weeks.insert(firstDate.createPreviousWeek(), at: 0)
                weeks.removeLast()
                weekIndex = 1
            }

            if let lastDate = weeks[weekIndex].last?.date, weekIndex == (weeks.count - 1) {
                /// Appending New Week at Last Index and Removing First Array Item
                weeks.append(lastDate.createNextWeek())
                weeks.removeFirst()
                weekIndex = weeks.count - 2
            }
        }
    }

    // Returns if selectedDay date is same day with parameters date
    func isSelected(_ day: WeekDay) -> Bool {
        selectedDay.date.isSame(day.date)
    }
}


// MARK: - To Do List Methods

extension DailyViewModel {

    func fetchItems() {
        executeDBOperation(.fetch)
    }

    func update(_ item: ToDoItem) {
        executeDBOperation(.update(item))
        sortItems()
    }

    func save(_ item: ToDoItem) {
        executeDBOperation(.save(item))
    }

    func insertAndSaveEmptyItem() {
        let date = selectedDay.date.weekdayFormat()
        let emptyItem = ToDoItem(date: date)
        items.insert(emptyItem, at: 0)
        save(emptyItem)
    }

    func deleteItems(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let item = self.items[index]
            items.remove(at: index)
            executeDBOperation(.delete(item))
        }
    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        items.move(fromOffsets: indexSet, toOffset: newIndex)
    }

    private func executeDBOperation(_ action: DailyServiceActions) {
        Task {
            do {
                switch action {
                case .fetch:
                    let date = selectedDay.date.weekdayFormat()
                    let endpoint = DailyEndpoint.getItems(forDate: date)
                    self.items = try await FirestoreService.request(endpoint)
                    sortItems()
                case .update(let item):
                    let endpoint = DailyEndpoint.updateItem(item)
                    try await FirestoreService.request(endpoint)
                case .save(let item):
                    let endpoint = DailyEndpoint.createItem(item)
                    try await FirestoreService.request(endpoint)
                case .delete(let item):
                    let endpoint = DailyEndpoint.deleteItem(item)
                    try await FirestoreService.request(endpoint)
                }
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    private func sortItems() {
        if items.contains(where: { $0.title.isEmpty }) {
            items.sort(by: { ($0.title.isEmpty && !$1.title.isEmpty) || (!$0.isDone && $1.isDone) })
        } else {
            items.sort(by: { !$0.isDone && $1.isDone })
        }
    }
}

fileprivate enum DailyServiceActions {
    case fetch
    case update(ToDoItem)
    case save(ToDoItem)
    case delete(ToDoItem)
}

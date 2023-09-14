//
//  DailyViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-09.
//

import SwiftUI
import FirebaseFirestore

@MainActor
final class DailyViewModel: ObservableObject {

    /// Week Slider Properties
    @Published var selectedDay: WeekDay
    @Published var weekIndex: Int = 1
    @Published var weeks: [[WeekDay]] = []
    @Published var createWeek: Bool = false

    /// To Do List Properties
    @Published var items: [ToDoItemModel] = []

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var userId: String

    init(userId: String) {
        self.userId = userId
        selectedDay = WeekDay(date: Date())
        fetchItems()
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
        handleDB(.fetch)
    }

    func update(_ item: ToDoItemModel) {
        handleDB(.update(item))
        sortItems()
    }

    func save(_ item: ToDoItemModel) {
        handleDB(.save(item))
    }

    func insertAndSaveEmptyItem() {
        let date = selectedDay.date.weekdayFormat()
        let emptyItem = ToDoItemModel(date: date)
        items.insert(emptyItem, at: 0)
        save(emptyItem)
    }

    func deleteItems(at indexSet: IndexSet) {
        indexSet.forEach { index in
            let item = self.items[index]
            items.remove(at: index)
            handleDB(.delete(item))
        }
    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        items.move(fromOffsets: indexSet, toOffset: newIndex)
    }

    private func handleDB(_ action: DailyServiceActions) {
        Task {
            do {
                switch action {
                case .fetch:
                    self.items = try await DailyService.get(for: selectedDay.date, userId: userId)
                    sortItems()
                case .update(let item):
                    try await DailyService.put(item: item, userId: userId)
                case .save(let item):
                    try await DailyService.post(item: item, userId: userId)
                case .delete(let item):
                    try await DailyService.delete(for: item, userId: userId)
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
    case update(ToDoItemModel)
    case save(ToDoItemModel)
    case delete(ToDoItemModel)
}

//
//  DailyViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-09.
//

import SwiftUI
import FirebaseFirestore

@MainActor
class DailyViewModel: ObservableObject {

    /// Week Slider Properties
    @Published var selectedDay: WeekDay = WeekDay(date: .init())
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

        print("Weeks Count: ", weeks.count)
    }

    // Returns if selectedDay date is same day with parameters date
    func isSelected(_ day: WeekDay) -> Bool {
        selectedDay.date.isSame(day.date)
    }
}


// MARK: - To Do List Methods

extension DailyViewModel {

    func fetchItems() {
        Task {
            do {
                self.items = try await WeekDayService.get(for: selectedDay.date, userId: userId)
                self.reorder()
            } catch {
                showAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }

    func reorder() {
        if items.contains(where: { $0.title.isEmpty }) {
            items.sort(by: { ($0.title.isEmpty && !$1.title.isEmpty) || (!$0.isDone && $1.isDone) })
        } else {
            items.sort(by: { !$0.isDone && $1.isDone })
        }
    }

    func deleteItems(at indexSet: IndexSet) {
        indexSet.forEach { index in
            Task {
                do {
                    let item = self.items[index]
                    try await WeekDayService.delete(for: item, userId: userId)
                } catch {
                    showAlert = true
                    errorMessage = error.localizedDescription
                }
            }
        }
    }

//    func deleteItems(at indexSet: IndexSet) {
//        indexSet.forEach { index in
//            Firestore.firestore()
//                .collection("users")
//                .document(userId)
//                .collection("weekdays")
//                .document(selectedDay.formatedDate())
//                .collection("items")
//                .document(items[index].id)
//                .delete { err in
//                    if let err = err {
//                        print("Error removing document: \(err)")
//                    } else {
//                        print("Document successfully removed!")
//                    }
//                }
//        }
//        items.remove(atOffsets: indexSet)
//    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        items.move(fromOffsets: indexSet, toOffset: newIndex)
    }

    func update(item: ToDoItemModel) {
        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("weekdays")
            .document(selectedDay.formatedDate())
            .collection("items")
            .document(item.id)
            .updateData(["title": item.title,
                         "isDone": item.isDone]) { error in

                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    print("Item updated")
                }
            }
        self.reorder()
    }

    func addNewItem() {
        let item = ToDoItemModel(date: selectedDay.date.weekdayFormat())

        // Save model
        Firestore.firestore()
            .collection ("users")
            .document(userId)
            .collection("weekdays")
            .document(selectedDay.date.weekdayFormat())
            .collection("items")
            .document (item.id)
            .setData(item.asDictionary())
    }
}

//
//  WeekSliderViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-10.
//

import SwiftUI

protocol WeekSliderViewModelProtocol: ObservableObject {
    var selectedDate: Date { get set }
    var weekIndex: Int { get set }
    var weeks: [Date.Week] { get set }
    var createWeek: Bool { get set }
    func setWeekData()
    func paginateWeek()
    func isSelected(_ day: Date.Day) -> Bool
}

class WeekSliderViewModel: WeekSliderViewModelProtocol {

    @Published var selectedDate: Date = .init()
    @Published var weekIndex: Int = 1
    @Published var weeks: [Date.Week] = []
    @Published var createWeek: Bool = false

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
    func isSelected(_ day: Date.Day) -> Bool {
        selectedDate.isSame(day.date)
    }
}

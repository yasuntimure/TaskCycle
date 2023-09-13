//
//  DateExtension.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-07.
//

import Foundation
import SwiftUI

extension Date {

    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    /// Checking Whether the Date is Today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    func fetchWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let starOfWeek = weekForDate?.start else {
            return []
        }
        // Iterating to get the Full Week
        (0..<7).forEach { index in
            if let weekDay = calendar.date (byAdding: .day, value: index, to: starOfWeek) {
                week.append(.init (date: weekDay))
            }
        }

        return week
    }

    /// Creating Next Week, based on the Last Current Week's Date
    func createNextWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }

        return fetchWeek(nextDate)
    }

    /// Creating Previous Week, based on the First Current Week's Date
    func createPreviousWeek() -> [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }

        return fetchWeek(previousDate)
    }

    /// Checking Two dates are same
    func isSame(_ date: Date) -> Bool {
        return Calendar.current.isDate(self, inSameDayAs: date)
    }

}

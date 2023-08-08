//
//  DateExtension.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-07.
//

import SwiftUI

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
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
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}

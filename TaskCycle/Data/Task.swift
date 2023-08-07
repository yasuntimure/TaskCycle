//
//  SwiftUIView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-07.
//

import SwiftUI

struct Task: Identifiable {
    var id: UUID = .init()
    var title: String
    var creationDate: Date = .init ()
    var isCompleted: Bool = false
    var tint: Color
}

var sampleTasks: [Task] = [
    .init(title: "Record Video", creationDate: .updateHour (-5), isCompleted: true, tint: .taskColor1),
    .init(title: "Redesign Website", creationDate: .updateHour (-3), tint: .taskColor2),
    .init(title: "Go for a Walk", creationDate: .updateHour(-4), tint: .taskColor3),
    .init(title: "Edit Video", creationDate: .updateHour (0), isCompleted: true, tint: .taskColor4),
    .init(title: "Publish Video", creationDate: .updateHour (2), isCompleted: true, tint: .taskColor1),
    .init(title: "Tweet about new Video!", creationDate: .updateHour(1), tint: .taskColor5),
]

extension Date {
    static func updateHour(_ value: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date (byAdding: .hour, value: value, to: .init()) ?? .init()
    }
}

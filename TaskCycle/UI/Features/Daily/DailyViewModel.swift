//
//  DailyViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-09.
//

import SwiftUI

protocol DailyViewModelProtocol: ObservableObject {
    var weekSliderViewModel: WeekSliderViewModel { get set }
    var toDoListViewModel: ToDoListViewModel { get set }
    var tasks: [Task] { get set }
    var createNewTask: Bool { get set }
    var settingsViewPresented: Bool { get set }
}

class DailyViewModel: DailyViewModelProtocol {

    /// Task Manager Properties
    @Published var weekSliderViewModel: WeekSliderViewModel
    @Published var toDoListViewModel: ToDoListViewModel
    @Published var tasks: [Task] = sampleTasks.sorted(by: { $1.creationDate > $0.creationDate })
    @Published var createNewTask: Bool = false
    @Published var settingsViewPresented = false


    let list = ToDoListModel(id: "111", title: "My Lust", description: "LustLust",
                             items: [ToDoListItemModel(id: "120", title: "My Item", description: "My description", date: Date().timeIntervalSince1970), ToDoListItemModel(id: "121", title: "My Item", description: "", date: Date().timeIntervalSince1970), ToDoListItemModel(id: "122", title: "My Item", description: "", date: Date().timeIntervalSince1970),
                                     ToDoListItemModel(id: "123", title: "My Item", description: "My description", date: Date().timeIntervalSince1970),
                                     ToDoListItemModel(id: "124", title: "My Item", description: "My description My description My description My description My description My description My description My description My description My description My description", date: Date().timeIntervalSince1970)],
                             date: Date().timeIntervalSince1970)

    init(userId: String) {
        weekSliderViewModel = WeekSliderViewModel()
        toDoListViewModel = ToDoListViewModel(userId: userId, list: list)
    }

}

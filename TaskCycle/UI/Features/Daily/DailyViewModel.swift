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
}

class DailyViewModel: DailyViewModelProtocol {

    /// Task Manager Properties
    @Published var weekSliderViewModel: WeekSliderViewModel
    @Published var toDoListViewModel: ToDoListViewModel
    @Published var tasks: [Task] = sampleTasks.sorted(by: { $1.creationDate > $0.creationDate })
    @Published var createNewTask: Bool = false

    init(userId: String, list: ToDoListModel) {
        weekSliderViewModel = WeekSliderViewModel()
        toDoListViewModel = ToDoListViewModel(userId: userId, list: list)
    }

}

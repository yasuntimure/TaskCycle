//
//  DailyTaskView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

struct DailyTaskView: View {

    @EnvironmentObject var viewModel: DailyViewModel

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView (.vertical, showsIndicators: false) {
                LazyVStack {
                    ForEach ($viewModel.items) { $todoItem in
                        DailyTaskRow(item: $todoItem)
                    }
                }
            }
            .refreshable {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    viewModel.fetchItems()
                }
            }


            PlusButton(size: 25) {
                viewModel.newItemId = ""
                viewModel.addNewItem()
                viewModel.fetchItems()
            }
            .vSpacing(.bottom).hSpacing(.trailing)
            .padding([.trailing,.bottom], 20)
        }

    }
}

struct DailyTaskView_Previews: PreviewProvider {
    static var previews: some View {
        DailyTaskView()
            .environmentObject(DailyViewModel(userId: "5JK0lwRArPULkWLO6Xf9DPxdo073"))
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

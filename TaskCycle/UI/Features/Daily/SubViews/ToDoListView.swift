//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

struct ToDoListView: View {

    @EnvironmentObject var viewModel: DailyViewModel

    var body: some View {
        NavigationView {
            ZStack {
                if viewModel.isLoading {
                    LoadingView()
                        .frame(width: 50, height: 50, alignment: .center)
                }

                ScrollView {
                    LazyVStack {
                        ForEach ($viewModel.items) { $todoItem in
                            ToDoListRow(isNew: todoItem.id == viewModel.newItemId,
                                        item: $todoItem)
                            .onTapGesture {
                                viewModel.isEditing = true
                                viewModel.newItemId = ""
                            }
                        }
                    }
                }
                .refreshable {
                    viewModel.fetchItems()
                }
                .listStyle(.plain)


                if !viewModel.isEditing {
                    PlusButton(size: 25) {
                        viewModel.newItemId = ""
                        viewModel.addNewItem()
                        viewModel.fetchItems()
                        viewModel.isEditing = true
                    }
                    .vSpacing(.bottom).hSpacing(.trailing)
                    .padding([.trailing,.bottom], 20)
                }
            }
        }
    }
}

struct ToDoListView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoListView()
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

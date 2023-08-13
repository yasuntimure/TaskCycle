//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

struct ToDoListView<VM>: View where VM: ToDoListViewModelProtocol {

    @ObservedObject var viewModel: VM

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                LoadingView()
                    .frame(width: 50, height: 50, alignment: .center)
            }

            ScrollView {
                LazyVStack {
                    ForEach ($viewModel.items) { $todoItem in
                        ToDoListRow(item: $todoItem.onNewValue {
                            withAnimation {
                                viewModel.updateIsDoneStatus(of: todoItem)
                            }
                        })
                        .onTapGesture {
                            withAnimation {
                                viewModel.isEditing = true
                            }
                        }

                    }
                    .onDelete(perform: viewModel.deleteItems(at:))
                    .onMove(perform: viewModel.moveItems(from:to:))
                }
            }
            .onAppear {
                //                    viewModel.fetchItems()
            }
            .refreshable {
                //                    viewModel.fetchItems()
            }
            //                .toolbar {
            //                    ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            //                }
            .listStyle(.plain)
            //                .sheet(isPresented: $viewModel.newItemViewPresented) {
            //                    NewItemView()
            //                        .presentationDetents([.fraction(0.55)])
            //                        .environmentObject(viewModel)
            //                }

            if viewModel.isEditing {
                KeyboardButton {
                    hideKeyboard()
                    viewModel.isEditing = false
                }
                .vSpacing(.bottom).hSpacing(.trailing)
                .padding(.trailing, 20).padding(.bottom, 10)
            } else {
                PlusButton(size: 25) {
                    viewModel.newItem.isPresented = true
                }
                .vSpacing(.bottom).hSpacing(.trailing)
                .padding([.trailing,.bottom], 20)
            }


            //            if viewModel.isEditing && viewModel.selectedItem != nil {
            //                EditItemView(item: viewModel.selectedItem!)
            //                    .scaleEffect(viewModel.isEditing ? 1.0 : 0.1)
            //                    .animation(.spring(response: 0.5, dampingFraction: 0.6, blendDuration: 0))
            //                    .vSpacing(.top)
            //
            //            }

        }
    }


}

struct ToDoListView_Previews: PreviewProvider {

    static let list = ToDoListModel(id: "111", title: "My Lust", description: "LustLust",
                                    items: [ToDoListItemModel(id: "120", title: "My Item", description: "My description", date: Date().timeIntervalSince1970), ToDoListItemModel(id: "121", title: "My Item", description: "", date: Date().timeIntervalSince1970), ToDoListItemModel(id: "122", title: "My Item", description: "", date: Date().timeIntervalSince1970),
                                            ToDoListItemModel(id: "123", title: "My Item", description: "My description", date: Date().timeIntervalSince1970),
                                            ToDoListItemModel(id: "124", title: "My Item", description: "My description My description My description My description My description My description My description My description My description My description My description", date: Date().timeIntervalSince1970)],
                                    date: Date().timeIntervalSince1970)
    static var previews: some View {
        ToDoListView(viewModel: ToDoListViewModel(userId: "", list: list))
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

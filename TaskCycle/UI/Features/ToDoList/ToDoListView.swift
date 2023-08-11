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
                    LazyVStack (spacing: 10) {
                        ForEach ($viewModel.items) { $todoItem in
                            ToDoListItemRow(item: $todoItem.onNewValue {
                                withAnimation {
                                    viewModel.updateIsDoneStatus(of: todoItem)
                                }
                            })
                            .padding(.all, 13)
                            .background(Color.backgroundColor)
                            .cornerRadius(15)
                            .shadow(radius: 2)

                        }
                        .onDelete(perform: viewModel.deleteItems(at:))
                        .onMove(perform: viewModel.moveItems(from:to:))
                    }
                    .padding(.top)
                    .padding(.horizontal)
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

                PlusButton(size: 25) {
                    viewModel.newItem.isPresented = true
                }
                .vSpacing(.bottom).hSpacing(.trailing)
                .padding([.trailing,.bottom], 20)
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

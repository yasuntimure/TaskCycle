//
//  ToDoListView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import SwiftUI

struct ToDoListView: View {

    @StateObject var viewModel: ToDoListViewModel

    var body: some View {
        ZStack {
            List {
                ForEach ($viewModel.items) { $item in
                    ToDoRow(item: $item.onNewValue {
                        withAnimation {
                            viewModel.update(item)
                        }
                    })
                        .padding(.vertical, -5)
                        .hSpacing(.leading)
                }
                .onDelete(perform: viewModel.deleteItems(at:))
                .onMove(perform: viewModel.moveItems(from:to:))
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            }

            PlusButton() {
                viewModel.addNewItem()
            }
            .hSpacing(.trailing).vSpacing(.bottom)
            .padding([.trailing, .bottom], 20)
        }
    }
}

#Preview {
    ToDoListView(viewModel: ToDoListViewModel(service: ToDoNoteService(noteId: Mock.note.id)))
}

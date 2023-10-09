//
//  ToDoListView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import SwiftUI

struct ToDoListView: View {

    @EnvironmentObject var vm: NoteViewModel

    var body: some View {
        ZStack {
            List {
                ForEach ($vm.items) { $item in
                    ToDoRow(item: $item)
                        .padding(.vertical, -5)
                        .hSpacing(.leading)
                }
                .onDelete { vm.items.remove(atOffsets: $0) }
                //                .onMove(perform: viewModel.moveItems(from:to:))
                .listSectionSeparator(.hidden)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
            }

            PlusButton() {
                vm.items.insert(ToDoItem(), at: 0)
            }
            .hSpacing(.trailing).vSpacing(.bottom)
            .padding([.trailing, .bottom], 20)
        }
    }
}

#Preview {
    ToDoListView()
}

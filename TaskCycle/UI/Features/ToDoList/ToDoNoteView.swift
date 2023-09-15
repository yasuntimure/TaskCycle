//
//  ToDoListView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

struct ToDoNoteView: View {

    @EnvironmentObject var notesViewModel: NotesViewModel

    @ObservedObject var viewModel: ToDoNoteViewModel

    @FocusState var titleFocused: Bool

    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                TextField("Title...", text: $viewModel.note.title)
                    .font(.largeTitle).bold()
                    .padding()
                    .focused($titleFocused)
                    .onSubmit {
                        if viewModel.note.items.isEmpty {
                            viewModel.addNewItem()
                        }
                    }

                List {
                    if viewModel.note.items.isEmpty {
                        PlaceholderToDoRow()
                            .onTapGesture { viewModel.addNewItem() }
                    } else {
                        ListRow()
                    }
                }
                .listStyle(.plain)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
                }


            }
            .vSpacing(.top)

            PlusButton() {
                viewModel.addNewItem()
            }
            .vSpacing(.bottom).hSpacing(.trailing)
            .padding([.trailing,.bottom], 20)
        }
        .toolbarKeyboardDismiss()
        .onAppear {
            titleFocused = viewModel.note.title.isEmpty
        }
        .onDisappear {
            if viewModel.uncompletedNote {
                viewModel.deleteNote()
            } else {
                viewModel.updateNote()
                notesViewModel.fetchNotes()
            }
        }
    }

    @ViewBuilder
    private func ListRow() -> some View {
        ForEach ($viewModel.note.items) { $item in
            ToDoRow(item: $item)
                .padding(.vertical, -5)
                .hSpacing(.leading)
        }
        .onDelete(perform: viewModel.deleteItems(at:))
        .onMove(perform: viewModel.moveItems(from:to:))
        .listSectionSeparator(.hidden)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}


struct ToDoNoteView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoNoteBuilder.make(userId: Mock.userId, note: Mock.note)
            .environmentObject(NotesViewModel())
    }
}

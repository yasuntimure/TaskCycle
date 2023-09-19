//
//  NoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-17.
//

import SwiftUI

enum NoteTextFields: String {
    case title
    case description
}

struct NoteView: View {
    @EnvironmentObject var parentVM: NotesViewModel
    @EnvironmentObject var theme: Theme
    @ObservedObject var viewModel: NoteViewModel
    @FocusState var focusState: NoteTextFields?

    var body: some View {
        ZStack {
            VStack (alignment: .leading) {
                TextField("Title...", text: $viewModel.title)
                    .titleFont(for: viewModel.type() ?? .empty)
                    .focused($focusState, equals: .title)
                    .onSubmit { focusState = .description }
                    .padding(.horizontal)

                TextField("Description . . .", text: $viewModel.description, axis: .vertical)
                    .descriptionFont(for: viewModel.type() ?? .empty)
                    .foregroundColor(.secondary)
                    .focused($focusState, equals: .description)
                    .padding(.horizontal)

                VStack (alignment: .leading) {
                    if viewModel.isNoteConfVisible {
                        NoteConfigurationView()
                    } else {
                        switch viewModel.type() ?? .empty {
                        case .empty: Divider().opacity(0)
                        case .todo: ToDoListView()
                        case .board: 
                            BoardNoteView(kanbanColumns: $viewModel.kanbanColumns)
                                .environmentObject(viewModel)
                        }
                    }
                }
                .hSpacing(.leading)

                Spacer()
            }
        }
        .toolbarKeyboardDismiss()
        .onAppear {
            focusState = viewModel.initialFocusState()
        }
        .onDisappear {
            if viewModel.uncompletedNote {
                viewModel.deleteNote()
            } else {
                viewModel.updateNote()
            }
            parentVM.fetchNotes()
        }

    }

    @ViewBuilder
    private func CustomButton(_ title: String,
                              image: String,
                              action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack (spacing: 3) {
                Image(systemName: image)
                    .font(.subheadline)
                Text(title)
                    .font(.subheadline)
            }
            .foregroundStyle(.gray)
            .padding(10)
            .layeredBackground(Color.backgroundColor, cornerRadius: 8)
        }
    }

    @ViewBuilder
    private func NoteConfigurationView() -> some View {
        VStack (alignment: .leading, spacing: 25) {
            CustomButton("Empty Page", image: "plus") {
                withAnimation {
                    viewModel.isNoteConfVisible = false
                }
            }

            VStack (alignment: .leading, spacing: 10) {
                Text("Add New")
                    .font(.footnote).bold()
                    .foregroundStyle(theme.mTintColor)
                CustomButton("To Do List", image: "checkmark.square") {
                    withAnimation {
                        viewModel.noteType = NoteType.todo.rawValue
                        viewModel.isNoteConfVisible = false
                    }
                }
                CustomButton("Kanban Board", image: "tablecells") {
                    withAnimation {
                        viewModel.noteType = NoteType.board.rawValue
                        viewModel.isNoteConfVisible = false
                    }
                }
            }
        }.padding()
    }

    @ViewBuilder
    func ToDoListView() -> some View {
        ZStack {
            List {
                ForEach ($viewModel.items) { $item in
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
    NoteView(viewModel: NoteViewModel(Mock.note))
        .environmentObject(Theme())
        .environmentObject(NotesViewModel())
}

fileprivate extension TextField {
    func titleFont(for noteType: NoteType) -> some View {
        switch noteType {
        case .empty:
            return self.font(.largeTitle).bold()
        case .todo:
            return self.font(.title).bold()
        case .board:
            return self.font(.title2).bold()
        }
    }

    func descriptionFont(for noteType: NoteType) -> some View {
        switch noteType {
        case .empty:
            return self.font(.title2)
        case .todo:
            return self.font(.title3)
        case .board:
            return self.font(.body)
        }
    }
}

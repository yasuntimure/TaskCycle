//
//  KanbanTaskDetailView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-20.
//

import SwiftUI

struct KanbanTaskDetailView: View {
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var viewModel: NoteViewModel

    @State private var isNoteConfVisible: Bool = true
    @FocusState var focusState: NoteTextFields?

    @State var task: TaskModel

    var body: some View {
        VStack (alignment: .leading) {
            TextField("Title...", text: $task.title)
                .titleFont(for: task.type() ?? .empty)
                .focused($focusState, equals: .noteTitle)
                .onSubmit { focusState = .noteDescription }
                .padding(.horizontal)

            TextField("Description . . .", text: $task.description, axis: .vertical)
                .descriptionFont(for: task.type() ?? .empty)
                .foregroundColor(.secondary)
                .focused($focusState, equals: .noteDescription)
                .padding(.horizontal)
                .descriptionPadding(for: task.type())


            VStack (alignment: .leading) {
                if isNoteConfVisible {
                    NoteConfigurationView()
                } else {
                    if task.noteType == NoteType.todo.rawValue {
                        ToDoListView()
                    }
                }
            }
            .hSpacing(.leading)
            .vSpacing(.top)
        }
        .onAppear {
            focusState = viewModel.initialFocusState()
        }
        .onDisappear {
            viewModel.updateNote()
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
                    isNoteConfVisible = false
                }
            }

            VStack (alignment: .leading, spacing: 10) {
                Text("Add New")
                    .font(.footnote).bold()
                    .foregroundStyle(theme.mTintColor)
                CustomButton("To Do List", image: "checkmark.square") {
                    withAnimation {
                        task.noteType = NoteType.todo.rawValue
                        isNoteConfVisible = false
                    }
                }
            }
        }.padding()
    }

    @ViewBuilder
    func ToDoListView() -> some View {
        ZStack {
            List {
                ForEach ($task.items) { $item in
                    ToDoRow(item: $item)
                        .padding(.vertical, -5)
                        .hSpacing(.leading)
                }
//                .onDelete(perform: viewModel.deleteItems(at:))
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
                viewModel.addNewItem()
            }
            .hSpacing(.trailing).vSpacing(.bottom)
            .padding([.trailing, .bottom], 20)
        }
    }

}

#Preview {
    KanbanTaskDetailView(task: Mock.task)
        .environmentObject(Theme())
        .environmentObject(NoteViewModel(Mock.note))
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

fileprivate extension View {
    @ViewBuilder
    func descriptionPadding(for noteType: NoteType?) -> some View {
        if let noteType = noteType, noteType == .empty {
            self.vSpacing(.top)
        }
        self
    }
}

//"""
//users: {
//    weekDays: [ToDoItemModel];
//    notes: [NoteModel] {
//        note: NoteModel {
//            id: String,
//            title: String,
//            description: String,
//            items: [ToDoItemModel],
//            date: String,
//            emoji: String?,
//            noteType: String?,
//            kanbanColumns: [KanbanModel] {
//                kanban: KanbanModel {
//                    id: String,
//                    title: String,
//                    tasks: [KanbanTaskModel] {
//                        note: KanbanTaskModel {
//                            id: String,
//                            title: String,
//                            description: String,
//                            items: [ToDoItemModel],
//                            date: String,
//                            emoji: String?,
//                            noteType: String?
//                        }
//                    }
//                }
//            }
//        }
//    }
//}
//"""


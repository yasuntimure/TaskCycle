//
//  KanbanView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-18.
//

import SwiftUI
import Algorithms

struct BoardColumnView: View {
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var viewModel: BoardNoteViewModel

    @State var isTargeted: Bool = false
    @FocusState var focusState: NoteTextFields?

    @Binding var column: BoardColumn

    var body: some View {
        VStack(alignment: .leading) {
            KanbanHeader()
                .padding(.horizontal, 5)

            KanbanBody()
                .hSpacing(.center).padding(.top, 9)
                .layeredBackground(
                    self.isTargeted ? theme.mTintColor.opacity(0.1) : .backgroundColor,
                    cornerRadius: 8
                )
                .dropDestination(for: Note.self) { droppedTasks, location in
                    column.tasks += droppedTasks
                    viewModel.removeDroppedTask(droppedTasks, kanban: column)
                    return true
                } isTargeted: { isTargeted in
                    self.isTargeted = isTargeted
                }
        }
    }

    @ViewBuilder
    private func KanbanHeader() -> some View {
        HStack {
            TextField("Title...", text: $column.title)
                .font(.body).bold()
                .padding([.vertical], 5)
                .focused($focusState, equals: .kanbanTitle)
            Spacer()
            Menu {
                Button(action: {
                    withAnimation {
                        viewModel.delete(column)
                    }
                }) {
                    Label("Delete", systemImage: "trash")
                }

                Button(action: {
                    withAnimation {
                        viewModel.duplicate(column)
                    }
                }) {
                    Label("Duplicate", systemImage: "plus.square.on.square")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.body)
                    .foregroundStyle(.black)
                    .padding([.vertical, .leading], 12)
                    .padding(.trailing, 5)
            }
        }
    }

    @ViewBuilder
    private func KanbanBody() -> some View {
        ScrollView(showsIndicators: false) {
            // Tasks
            VStack (spacing: -12) {
                ForEach($column.tasks, id: \.id) { $taskCard in
                    TaskCardView(task: $taskCard)
                    .draggable(taskCard)
                    .padding(12)
                }
            }
            .padding(.bottom, -12)

            // Add Task Button
            SecondaryButton(imageName: "plus", title: "Add Task",
                            backgroundColor: theme.mTintColor.opacity(0.15))
            {
                column.tasks.append(Note())
            }
            .padding(.vertical, 6).padding(.horizontal, 12)
        }
    }

}

#Preview {
    BoardColumnView(column: .constant(BoardColumn()))
        .environmentObject(Theme())
        .environmentObject(NoteViewModel(Mock.note))
}


protocol BoardColumnActions {
    func deleteColumn(noteID: String, columnId: String) // header delete column
    func updateColumn(noteID: String, columnId: String) // when new tasks added
    func createColumn(noteID: String, columnId: String) // when new addNewColumn
}

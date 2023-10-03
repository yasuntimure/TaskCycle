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

    @Binding var kanban: KanbanModel {
        didSet {
            viewModel.update(kanban)
        }
    }

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
                .dropDestination(for: NoteModel.self) { droppedTasks, location in
                    kanban.tasks += droppedTasks
                    viewModel.removeDroppedTask(droppedTasks, kanban: kanban)
                    return true
                } isTargeted: { isTargeted in
                    self.isTargeted = isTargeted
                }
        }
    }

    @ViewBuilder
    private func KanbanHeader() -> some View {
        HStack {
            TextField("Title...", text: $kanban.title)
                .font(.body).bold()
                .padding([.vertical], 5)
                .focused($focusState, equals: .kanbanTitle)
            Spacer()
            Menu {
                Button(action: {
                    withAnimation {
                        viewModel.delete(kanban)
                    }
                }) {
                    Label("Delete", systemImage: "trash")
                }

                Button(action: {
                    withAnimation {
                        viewModel.duplicate(kanban)
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
                ForEach($kanban.tasks, id: \.id) { $taskCard in
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
                kanban.tasks.append(NoteModel())
            }
            .padding(.vertical, 6).padding(.horizontal, 12)
        }
    }

}

#Preview {
    BoardColumnView(kanban: .constant(KanbanModel()))
        .environmentObject(Theme())
        .environmentObject(NoteViewModel(Mock.note))
}

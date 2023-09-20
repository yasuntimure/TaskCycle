//
//  KanbanView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-18.
//

import SwiftUI
import Algorithms

struct KanbanColumnView: View {

    @EnvironmentObject var theme: Theme
    @EnvironmentObject var viewModel: NoteViewModel

    @State var kanban: Kanban

    @State var isTargeted: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            KanbanHeader()
            VStack {
                ScrollView(showsIndicators: false) {
                    // Tasks
                    VStack (spacing: -12) {
                        ForEach($kanban.tasks, id: \.id) { $task in
                            KanbanTaskView(note: $task)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .draggable(task)
                        }
                    }
                    .padding(.bottom, -12)

                    // Add New Button
                    SecondaryButton(imageName: "plus",
                                    title: "Add Task",
                                    backgroundColor: theme.mTintColor.opacity(0.15)) {
                        viewModel.addTask(to: kanban)
                    }.padding(.vertical, 6).padding(.horizontal, 12)
                }
                .hSpacing(.center)
            }
            .layeredBackground(
                self.isTargeted ? theme.mTintColor.opacity(0.1) : .backgroundColor,
                cornerRadius: 8
            )
            .dropDestination(for: NoteModel.self) { droppedTasks, location in
                viewModel.removeDroppedTasks(from: kanban, droppedTasks: droppedTasks)
                viewModel.addDroppedTasks(to: kanban, droppedTasks: droppedTasks)
                return true
            } isTargeted: { isTargeted in
                self.isTargeted = isTargeted
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical)
    }

    @ViewBuilder
    private func KanbanHeader() -> some View {
        HStack {
            TextField("Title...", text: $kanban.title)
                .font(.body).bold()
                .padding([.vertical], 5)
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
}

#Preview {
    KanbanColumnView(kanban: Kanban(KanbanModel()))
        .environmentObject(Theme())
        .environmentObject(NoteViewModel(Mock.note))
}

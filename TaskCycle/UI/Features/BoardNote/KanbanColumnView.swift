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
            VStack {
                ScrollView(showsIndicators: false) {
                    // Tasks
                    VStack (spacing: -12) {
                        ForEach(kanban.tasks, id: \.id) { task in
                            TaskRow(note: task)
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

    @ViewBuilder func TaskRow(note: NoteModel) -> some View {
        HStack(spacing: 10) {
            VStack {
                if let emoji = note.emoji {
                    Text(emoji)
                        .font(.largeTitle)
                } else {
                    Image(systemName: note.type()?.systemImage ?? NoteType.empty.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(theme.mTintColor)
                        .minimumScaleFactor(0.1)
                        .scaledToFit()
                }
            }

            VStack (alignment: .leading, spacing: 2) {
                Text(note.title)
                    .font(.headline)

                if !note.description.isEmpty {
                    Text(note.description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
            }
        }
        .hSpacing(.leading)
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .layeredBackground(.white, cornerRadius: 8)
    }

}

#Preview {
    KanbanColumnView(kanban: Kanban(KanbanModel()))
        .environmentObject(Theme())
        .environmentObject(NoteViewModel(Mock.note))
}

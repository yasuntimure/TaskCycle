//
//  KanbanView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-18.
//

import SwiftUI

struct KanbanColumnView: View {

    @EnvironmentObject var theme: Theme
    @EnvironmentObject var viewModel: NoteViewModel

    @State var column: KanbanColumn

    var body: some View {
        VStack(alignment: .leading) {
            VStack {
                ScrollView(showsIndicators: false) {
                    // Tasks
                    VStack (spacing: -12) {
                        ForEach(column.tasks, id: \.id) { task in
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
                        viewModel.addNewTask(to: column)
                    }.padding(.vertical, 6).padding(.horizontal, 12)
                }
                .hSpacing(.center)
            }
            .layeredBackground(
                column.isTargeted ? theme.mTintColor.opacity(0.1) : .backgroundColor,
                cornerRadius: 8
            )
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
    KanbanColumnView(column: KanbanColumn())
        .environmentObject(Theme())
        .environmentObject(NoteViewModel(note: Mock.note))
}

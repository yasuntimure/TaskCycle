//
//  BoardNoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import SwiftUI
import Algorithms

struct BoardNoteView: View {

    @ObservedObject var viewModel: BoardNoteViewModel

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 12) {
                KanbanView(title: "To Do", 
                           tasks: viewModel.note.toDoTasks,
                           isTargeted: viewModel.isToDoTargeted,
                           isLandscape: isLandscape(proxy.size))
                    .dropDestination(for: NoteModel.self) { droppedTask, location in
                        viewModel.handleDropAction(droppedTask, for: .todo)
                    } isTargeted: { isTargeted in
                        viewModel.isToDoTargeted = isTargeted
                    }


                KanbanView(title: "In Progress", 
                           tasks: viewModel.note.inProgressTasks,
                           isTargeted: viewModel.isInProgressTargeted,
                           isLandscape: isLandscape(proxy.size))
                    .dropDestination(for: NoteModel.self) { droppedTask, location in
                        viewModel.handleDropAction(droppedTask, for: .inprogress)
                    } isTargeted: { isTargeted in
                        viewModel.isInProgressTargeted = isTargeted
                    }


                KanbanView(title: "Done", tasks:
                            viewModel.note.doneTasks,
                           isTargeted: viewModel.isDoneTargeted,
                           isLandscape: isLandscape(proxy.size))
                    .dropDestination(for: NoteModel.self) { droppedTask, location in
                        viewModel.handleDropAction(droppedTask, for: .done)
                    } isTargeted: { isTargeted in
                        viewModel.isDoneTargeted = isTargeted
                    }
            }
            .padding()
            .environmentObject(viewModel)
        }
    }

    func isLandscape(_ size: CGSize) -> Bool {
        size.width > size.height
    }

}

struct BoardNoteView_Previews: PreviewProvider {
    static var previews: some View {
        BoardNoteView(viewModel: BoardNoteViewModel(note: Mock.note))
            .environmentObject(Theme())
            .environmentObject(BoardNoteViewModel(note: Mock.note))
    }
}

struct KanbanView: View {
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var viewModel: BoardNoteViewModel
    let title: String
    let tasks: [NoteModel]
    let isTargeted: Bool
    let isLandscape: Bool

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.footnote.bold())

            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(isTargeted ? .teal.opacity(0.15) : Color(.secondarySystemFill))

                VStack(alignment: .leading, spacing: 10) {
                    ForEach(tasks, id: \.self) { taskNote in
                        TaskRow(note: taskNote,
                                isLandscape: isLandscape)
                        .draggable(taskNote)
                    }

                    Button {
                        viewModel.addTemplateNote()
                    } label: {
                        HStack(spacing: 2) {
                            Image(systemName: "plus")
                                .font(.callout)
                                .foregroundColor(.black.opacity(0.6))

                            Text("Add New")
                                .font(.caption)
                                .foregroundColor(.black.opacity(0.6))
                                .lineLimit(1)
                        }
                        .hSpacing(.center)
                        .padding(.horizontal, isLandscape ? 15 : 5)
                        .padding(.vertical, 5)
                        .layeredBackground(theme.mTintColor.opacity(0.15), cornerRadius: 8)
                    }
                    Spacer()
                }
                .padding(.horizontal, 8)
                .padding(.vertical)
            }
        }
        .onDisappear {
            viewModel.updateNote()
        }
    }

    @ViewBuilder func TaskRow(note: NoteModel, isLandscape: Bool) -> some View {
        HStack(spacing: 10) {
            VStack {
                if isLandscape {
                    if let emoji = note.emoji {
                        Text(emoji)
                            .font(.largeTitle)
                    } else {
                        Image(systemName: note.type().systemImage)
                            .font(.largeTitle)
                            .foregroundColor(theme.mTintColor)
                            .minimumScaleFactor(0.1)
                            .scaledToFit()
                    }
                }
            }

            VStack (alignment: .leading, spacing: 2) {
                Text(note.title)
                    .font(isLandscape ? .headline : .caption)

                if !note.description.isEmpty {
                    Text(note.description)
                        .font(isLandscape ? .body : .caption2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
            }
        }
        .hSpacing(.leading)
        .padding(.horizontal, isLandscape ? 15 : 5)
        .padding(.vertical, 5)
        .layeredBackground(.white, cornerRadius: 8)
    }
}

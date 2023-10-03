//
//  KanbanTask.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-19.
//

import SwiftUI

struct KanbanTaskView: View {
    // Environment Objects
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var viewModel: NoteViewModel


    // View Properties
    @Binding var task: TaskModel
    @State var taskIsEditable: Bool = false
    @FocusState var focusState: NoteTextFields?

    var body: some View {
        HStack {
            /// Icon
            TaskIconView()

            /// Title & Description
            VStack (alignment: .leading, spacing: 2) {
                if taskIsEditable {
                    EditableTaskInputs()
                } else {
                    NavigationLink {
                        KanbanTaskDetailView(task: task)
                            .environmentObject(viewModel)
                    } label: {
                        UnEditableTaskTextView()
                    }
                }
            }
            .hSpacing(.leading)

            /// Ellipsis Menu
            TaskSettingsMenu()
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 9)
        .layeredBackground(.white, cornerRadius: 8)
        .onAppear { taskIsEditable = task.title.isEmpty }
    }

    @ViewBuilder
    private func TaskIconView() -> some View {
        VStack {
            if let emoji = task.emoji {
                Text(emoji)
                    .font(.title)
            } else {
                Image(systemName: task.type()?.systemImage ?? NoteType.empty.systemImage)
                    .font(.title)
                    .foregroundColor(theme.mTintColor)
                    .minimumScaleFactor(0.1)
                    .scaledToFit()
            }
        }
    }

    @ViewBuilder
    private func EditableTaskInputs() -> some View {
        TextField("Title...", text: $task.title)
            .font(.subheadline.bold())
            .multilineTextAlignment(.leading)
            .focused($focusState, equals: .kanbanTaskTitle)
            .onSubmit { taskIsEditable = false }

        if !task.description.isEmpty {
            TextField("Description...", text: $task.description)
                .font(.footnote)
                .multilineTextAlignment(.leading)
                .focused($focusState, equals: .kanbanTaskTitle)
                .onSubmit { taskIsEditable = false }
        }
    }

    @ViewBuilder
    private func UnEditableTaskTextView() -> some View {
        VStack (alignment: .leading, spacing: 2) {
            Text(task.title)
                .font(.subheadline.bold())
                .multilineTextAlignment(.leading)
                .foregroundColor(.primary)

            if !task.description.isEmpty {
                Text(task.description)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    private func TaskSettingsMenu() -> some View {
        Menu {
            Button(action: {
                withAnimation {
                    //viewModel.delete(kanban)
                }
            }) {
                Label("Delete", systemImage: "trash")
            }

            Button(action: {
                taskIsEditable = true
                focusState = .kanbanTaskTitle
            }) {
                Label("Edit", systemImage: "pencil")
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

#Preview {
    ZStack {
        Color.backgroundColor
            .ignoresSafeArea()

        KanbanTaskView(task: .constant(Mock.task))
            .environmentObject(Theme())
            .environmentObject(NoteViewModel(NoteModel.quickNote()))
            .padding(.horizontal, 50)
            .padding(.vertical, 350)
    }
}

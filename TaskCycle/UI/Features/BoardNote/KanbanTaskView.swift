//
//  KanbanTask.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-19.
//

import SwiftUI

struct KanbanTaskView: View {

    @EnvironmentObject var theme: Theme
    @FocusState var focusState: NoteTextFields?
    @Binding var note: NoteModel
    @EnvironmentObject var viewModel: NoteViewModel

    @State var taskIsEditable: Bool = false

    var body: some View {
        HStack {
            VStack {
                if let emoji = note.emoji {
                    Text(emoji)
                        .font(.title)
                } else {
                    Image(systemName: note.type()?.systemImage ?? NoteType.empty.systemImage)
                        .font(.title)
                        .foregroundColor(theme.mTintColor)
                        .minimumScaleFactor(0.1)
                        .scaledToFit()
                }
            }

            VStack (alignment: .leading, spacing: 2) {
                if taskIsEditable {
                    TextField("Title...", text: $note.title)
                        .font(.subheadline.bold())
                        .multilineTextAlignment(.leading)
                        .focused($focusState, equals: .kanbanTaskTitle)
                        .onSubmit {
                            viewModel.updateNote()
                            taskIsEditable = false
                        }

                    if !note.description.isEmpty {
                        TextField("Description...", text: $note.description)
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                            .focused($focusState, equals: .kanbanTaskTitle)
                            .onSubmit { taskIsEditable = false }
                    }
                } else {
                    NavigationLink {
                        KanbanTaskDetailView(note: $note)
                    } label: {
                        VStack (alignment: .leading, spacing: 2) {
                            Text(note.title)
                                .font(.subheadline.bold())
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.primary)

                            if !note.description.isEmpty {
                                Text(note.description)
                                    .font(.footnote)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
            .hSpacing(.leading)

            EditTaskButton()
        }
        .padding(.horizontal, 9)
        .padding(.vertical, 9)
        .layeredBackground(.white, cornerRadius: 8)
        .onAppear {
            taskIsEditable = note.title.isEmpty
        }
    }

    @ViewBuilder
    private func EditTaskButton() -> some View {
        Button(action: {
            taskIsEditable = true
            focusState = .kanbanTaskTitle
        }, label: {
            Image(systemName: "pencil")
                .font(.caption)
                .padding([.leading, .bottom], 5)
                .vSpacing(.top)
        })
    }
}

#Preview {
    ZStack {
        Color.backgroundColor
            .ignoresSafeArea()

        KanbanTaskView(note: .constant(Mock.note))
            .environmentObject(Theme())
            .environmentObject(NoteViewModel(NoteModel.quickNote()))
            .padding(.horizontal, 50)
            .padding(.vertical, 350)
    }
}

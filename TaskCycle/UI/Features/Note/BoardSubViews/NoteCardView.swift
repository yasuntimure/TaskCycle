//
//  KanbanTask.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-19.
//

import SwiftUI

struct NoteCardView: View {
    // Environment Objects
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var vm: NoteViewModel

    @FocusState var focusState: NoteTextFields?

    @Binding var note: Note
    var onDelete: () -> Void

    var body: some View {
        HStack {
            VStack (alignment: .leading, spacing: 2) {
                if vm.taskIsEditable {
                    HStack {
                        TaskIconView()
                        EditableTaskInputs()
                    }
                } else {
                    HStack {
                        TaskIconView()
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
        .onAppear { vm.taskIsEditable = note.title.isEmpty }
    }

    @ViewBuilder
    private func TaskIconView() -> some View {
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
    }

    @ViewBuilder
    private func EditableTaskInputs() -> some View {
        VStack (alignment: .leading, spacing: 2) {
            TextField("Title...", text: $note.title, axis: .vertical)
                .font(.subheadline.bold())
                .multilineTextAlignment(.leading)
                .focused($focusState, equals: .kanbanTaskTitle)
                .onSubmit { vm.taskIsEditable = false }

            if !note.description.isEmpty {
                TextField("Description...", text: $note.description)
                    .font(.footnote)
                    .multilineTextAlignment(.leading)
                    .focused($focusState, equals: .kanbanTaskTitle)
                    .onSubmit { vm.taskIsEditable = false }
            }
        }
        .hSpacing(.leading)
    }

    @ViewBuilder
    private func UnEditableTaskTextView() -> some View {
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
        .hSpacing(.leading)
    }

    @ViewBuilder
    private func TaskSettingsMenu() -> some View {
        Menu {
            Button(action: {
                withAnimation {
                    onDelete()
                }
            }) {
                Label("Delete", systemImage: "trash")
            }

            Button(action: {
                vm.taskIsEditable = true
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

        NoteCardView(note: .constant(Mock.note), onDelete: {})
            .environmentObject(Theme())
            .environmentObject(NoteViewModel(Note.quickNote()))
            .padding(.horizontal, 50)
            .padding(.vertical, 350)
    }
}

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
    @EnvironmentObject var vm: NoteViewModel

    @Binding var column: BoardColumn

    @State var isTargeted: Bool = false
    @FocusState var focusState: NoteTextFields?

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
                    var temp = self.column
                    temp.notes += droppedTasks
                    self.column = temp
                    vm.removeDroppedTask(droppedTasks, column: column)
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
                        vm.delete(column)
                    }
                }) {
                    Label("Delete", systemImage: "trash")
                }

                Button(action: {
                    withAnimation {
                        vm.duplicate(column)
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
                ForEach($column.notes, id: \.id) { $noteCard in
                    NoteCardView(note: $noteCard, onDelete: {
                        column.notes.removeAll(where: { $0.id == noteCard.id})
                    })
                    .draggable(noteCard)
                    .padding(12)
                }
            }
            .padding(.bottom, -12)

            // Add Task Button
            SecondaryButton(imageName: "plus", title: "Add Task",
                            backgroundColor: theme.mTintColor.opacity(0.15))
            {
                var temp = self.column
                temp.notes.append(Note())
                self.column = temp
            }
            .padding(.vertical, 6).padding(.horizontal, 12)
        }
    }

}

#Preview {
    BoardColumnView(column: .constant(Mock.column))
        .environmentObject(Theme())
}

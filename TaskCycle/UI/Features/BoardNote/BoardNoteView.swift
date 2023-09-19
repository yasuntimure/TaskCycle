//
//  BoardNoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import SwiftUI
import Algorithms

struct BoardNoteView: View {

    @Binding var kanbanColumns: [KanbanColumn]

    @EnvironmentObject var viewModel: NoteViewModel

    var body: some View {
            GeometryReader { geometry in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack (alignment: .top) {
                        LazyVGrid(columns: getGridColumns()) {
                            ForEach($kanbanColumns, id: \.id) { $kanbanColumn in
                                VStack (spacing: -15) {
                                    KanbanHeader($kanbanColumn)
                                    KanbanColumnView(column: kanbanColumn)
                                        .frame(height: geometry.size.height)
                                        .dropDestination(for: NoteModel.self) { droppedTasks, location in
                                            viewModel.removeDroppedTasksFromSource(droppedTasks)
                                            viewModel.addDroppedTasksToDestination(droppedTasks, to: kanbanColumn)
                                            return true
                                        } isTargeted: { isTargeted in
                                            kanbanColumn.isTargeted = isTargeted
                                        }
                                }
                            }
                            AddColumnButton()
                                .frame(height: geometry.size.height)
                        }
                    }
                    .padding(.horizontal)
                }
            }
    }

    func getGridColumns() -> [GridItem] {
        var columns: [GridItem] = []
        viewModel.kanbanColumns.forEach { _ in
            columns.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        }
        columns.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        return columns
    }


    @ViewBuilder
    private func KanbanHeader(_ bindingColumn: Binding<KanbanColumn>) -> some View {
        HStack {
            TextField("Title...", text: bindingColumn.title)
                .font(.body).bold()
                .padding(10)
            Spacer()
            Menu {
                Button(action: {
                    withAnimation {
                        viewModel.delete(bindingColumn.wrappedValue)
                    }
                }) {
                    Label("Delete", systemImage: "trash")
                }

                Button(action: {
                    withAnimation {
                        viewModel.duplicate(bindingColumn.wrappedValue)
                    }
                }) {
                    Label("Duplicate", systemImage: "plus.square.on.square")
                }
            } label: {
                Image(systemName: "ellipsis")
                        .font(.body)
                        .foregroundStyle(.black)
                        .padding()
            }
        }
    }

    @ViewBuilder
    private func AddColumnButton() -> some View {
        Button {
            withAnimation {
                viewModel.addKanbanColumn()
            }
        } label: {
            HStack {
                Image(systemName: "plus")
                Text("Add Column")
            }
            .font(.body).bold()
            .foregroundColor(.secondary)
            .hSpacing(.center).vSpacing(.center)
            .layeredBackground(.backgroundColor.opacity(0.4), cornerRadius: 8)
            .padding(.top, 42).padding(.bottom, 18).padding(.horizontal).padding(.leading, -8)
        }
    }
}


struct BoardNoteView_Previews: PreviewProvider {
    static var previews: some View {
        BoardNoteView(kanbanColumns: .constant([]))
            .environmentObject(Theme())
            .environmentObject(NoteViewModel(Mock.note))
    }
}

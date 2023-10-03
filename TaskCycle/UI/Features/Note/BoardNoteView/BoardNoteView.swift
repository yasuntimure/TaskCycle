//
//  BoardNoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import SwiftUI

struct BoardNoteView: View {

    @StateObject var viewModel: BoardNoteViewModel

    @State var height: CGFloat

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                LazyVGrid(columns: getGridColumns()) {
                    ForEach($viewModel.kanbans, id: \.id) { $kanban in
                        KanbanColumnView(kanban: kanban)
                            .frame(height: height)
                            .environmentObject(viewModel)
                    }
                    AddColumnButton()
                }
            }
            .padding(.horizontal)
        }
    }

    @ViewBuilder
    private func AddColumnButton() -> some View {
        Button {
            withAnimation {
//                viewModel.addKanbanColumn()
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

    func getGridColumns() -> [GridItem] {
        var columns: [GridItem] = []
        viewModel.kanbans.forEach { _ in
            columns.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        }
        columns.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        return columns
    }

}

#Preview {
    BoardNoteBuilder.make(id: Mock.note.id, height: 600)
}

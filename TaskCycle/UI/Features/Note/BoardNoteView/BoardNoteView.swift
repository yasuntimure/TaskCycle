//
//  BoardNoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import SwiftUI

struct BoardNoteView: View {

    @StateObject var viewModel: BoardNoteViewModel

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    LazyVGrid(columns: getGridColumns()) {
                        ForEach($viewModel.kanbans, id: \.id) { $kanban in
                            BoardColumnView(kanban: $kanban)
                                .frame(height: geometry.size.height)
                                .environmentObject(viewModel)
                        }
                        AddColumnButton()
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                viewModel.fetchKanbans()
            }
            .alert("Error", isPresented: $viewModel.showAlert) {
                Text(viewModel.errorMessage)
            }
        }
    }

    @ViewBuilder
    private func AddColumnButton() -> some View {
        Button {
            withAnimation {
                viewModel.addNewColumn()
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
    BoardNoteBuilder.make(id: Mock.note.id)
}

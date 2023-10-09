//
//  BoardNoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import SwiftUI

struct BoardNoteView: View {

    @EnvironmentObject var vm: NoteViewModel

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    LazyVGrid(columns: getGrids()) {
                        ForEach($vm.columns, id: \.id) { $column in
                            BoardColumnView(column: $column)
                                .frame(height: geometry.size.height)
                                .environmentObject(vm)
                        }
                        AddColumnButton()
                    }
                }
                .padding(.horizontal)
            }
            .alert("Error", isPresented: $vm.showAlert) {
                Menu("Error") {
                    Text(vm.errorMessage)
                }
            }
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {

                    Button(action: {
                        vm.updateNote()
                        hideKeyboard()
                        vm.taskIsEditable = false
                    }, label: { Image(systemName: "keyboard.chevron.compact.down.fill")
                            .font(.headline)
                        .tint(.secondary) })

                    Spacer()

                    Button(action: {
                        vm.updateNote()
                        hideKeyboard()
                        vm.taskIsEditable = false
                    }, label: {
                        Text("Save")
                            .font(.headline).bold()
                            .tint(.primary)
                    })
                }
            }

        }
    }

    func getGrids() -> [GridItem] {
        var grids: [GridItem] = []
        vm.columns.forEach { _ in
            grids.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        }
        grids.append(GridItem(.flexible(minimum: 300, maximum: 600)))
        return grids
    }

    @ViewBuilder
    private func AddColumnButton() -> some View {
        Button {
            withAnimation {
                vm.columns.append(BoardColumn())
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

#Preview {
    BoardNoteView()
}

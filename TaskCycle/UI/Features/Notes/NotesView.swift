//
//  NotesView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-18.
//

import SwiftUI

enum NoteStack: Hashable {
    case empty(note: NoteModel)
    case todo
    case board
}
struct NotesView: View {

    @ObservedObject var viewModel: NotesViewModel

    @State var noteStack: [NoteStack] = []

    var body: some View {
        NavigationStack(path: $noteStack) {
            VStack {
                HeaderView()

                ZStack {

                    // List View
                    List {
                        NoteNavigationRow()
                    }
                    .listStyle(.plain)
                    .background(.clear)
                    .refreshable {
                        viewModel.fetchNotes()
                    }
                    .sheet(isPresented: $viewModel.newNotePresented) {
                        NewNoteView()
                            .presentationDetents([.fraction(0.46)])

                    }
                    .sheet(isPresented: $viewModel.settingsPresented) {
                        SettingsView()
                            .presentationDetents([.fraction(0.45)])
                    }

                    // Edit Button
                    CustomEditButton()


                    // Add Button
                    PlusButton(size: 25) {
                        viewModel.saveEmptyNote { note in
                            noteStack.append(.empty(note: note))
                        }
                    }
                    .vSpacing(.bottom).hSpacing(.trailing)
                    .padding([.trailing,.bottom], 20)
                }
            }
            .navigationDestination(for: NoteStack.self) { value in
                switch value {
                case .empty(let note):
                    EmptyNoteBuilder.make(userId: viewModel.userId, note: note)
                case .todo:
                    Text("Todo")
                case .board:
                    Text("Board")
                }
            }
        }
        .environmentObject(viewModel)
    }
}

// MARK: - HeaderView

extension NotesView {

    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            HStack {
                // Title
                Text("Notes")
                    .font(.title.bold())
                    .hSpacing(.leading)
                    .foregroundColor(.mTintColor)

                // Settings Button
                Image(systemName: "gearshape")
                    .resizable()
                    .foregroundColor(.secondary)
                    .frame(width: 28, height: 28)
                    .onTapGesture {
                        viewModel.settingsPresented = true
                    }
            }
            .padding([.top, .horizontal])

            Rectangle()
                .frame(width: ScreenSize.width, height: 2)
                .foregroundColor(.backgroundColor)
        }
    }
}

// MARK: - NoteNavigationRow

extension NotesView {

    @ViewBuilder
    private func NoteNavigationRow() -> some View {
        ForEach ($viewModel.notes) { $note in
            NavigationLink {
                EmptyNoteBuilder.make(userId: viewModel.userId, note: note)
            } label: {
                NoteRow(note: $note)
            }
        }
        .onDelete(perform: viewModel.deleteItems(at:))
        .onMove(perform: viewModel.moveItems(from:to:))
        .listSectionSeparator(.hidden)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

// MARK: - CustomEditButton

extension NotesView {

    @ViewBuilder
    private func CustomEditButton() -> some View {
        ZStack {
            Image(systemName: "slider.horizontal.3")
                .resizable()
                .foregroundColor(.secondary)
                .frame(width: 28, height: 28)
            EditButton()
                .foregroundColor(.clear)
        }
        .hSpacing(.leading)
        .vSpacing(.bottom)
        .padding([.leading,.bottom], 28)
    }

}


struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel(userId: " "))
    }
}

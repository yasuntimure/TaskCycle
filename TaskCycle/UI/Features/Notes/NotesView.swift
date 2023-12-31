//
//  NotesView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-18.
//

import SwiftUI

enum NoteStack: Hashable {
    case empty(note: NoteModel)
    case todo(note: NoteModel)
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
                    .sheet(isPresented: $viewModel.settingsPresented) {
                        SettingsView()
                            .presentationDetents([.fraction(0.45)])
                    }

                    // Edit Button
                    CustomEditButton()


                    // Add Button
                    PlusButton(size: 25) {
                        viewModel.saveNewNote(type: .todo) { note in
                            navigateToReleated(note)
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
                case .todo(let note):
                    ToDoNoteBuilder.make(userId: viewModel.userId, note: note)
                case .board:
                    Text("Board")
                }
            }
        }
        .environmentObject(viewModel)
    }

    func navigateToReleated(_ note: NoteModel) {
        switch note.type() {
        case .empty:
            noteStack.append(.empty(note: note))
        case .todo:
            noteStack.append(.todo(note: note))
        case .board:
            noteStack.append(.todo(note: note))
        }
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
                let userId = viewModel.userId
                switch note.type() {
                case .empty:
                    EmptyNoteBuilder.make(userId: userId, note: note)
                case .todo:
                    ToDoNoteBuilder.make(userId: userId, note: note)
                case .board:
                    EmptyNoteBuilder.make(userId: userId, note: note)
                }
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


struct
NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel(userId: " "))
    }
}

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
    @State var noteTypeSelectionMode: Bool = false

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

                    // Add New Note Button
                    AddNewNoteButton()
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

                // Edit Button
                ZStack {
                    Image(systemName: "slider.horizontal.3")
                        .resizable()
                        .foregroundColor(.secondary)
                        .frame(width: 24, height: 24)
                    EditButton()
                        .foregroundColor(.clear)
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
            .padding(.horizontal)
            .padding(.vertical, 5)
            .hSpacing(.leading)
            .background(Color.backgroundColor)
            .cornerRadius(20)
        }
        .onDelete(perform: viewModel.deleteItems(at:))
        .onMove(perform: viewModel.moveItems(from:to:))
        .listSectionSeparator(.hidden)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

    @ViewBuilder
    private func AddNewNoteButton() -> some View {
        VStack (spacing: 15) {
            if noteTypeSelectionMode {
                NoteIconButton(.empty) {
                    viewModel.saveNewNote(type: .empty) { note in
                        navigateToReleated(note)
                    }
                }
                .padding(.top, 7)
                NoteIconButton(.todo) {
                    viewModel.saveNewNote(type: .todo) { note in
                        navigateToReleated(note)
                    }
                }
                NoteIconButton(.board) {
                    viewModel.saveNewNote(type: .board) { note in
                        navigateToReleated(note)
                    }
                }
            }

            PlusButton(size: 25) {
                withAnimation {
                    noteTypeSelectionMode.toggle()
                }
            }
        }
        .padding(10)
        .background(noteTypeSelectionMode ? Color.backgroundColor : .clear)
        .overlay(
            RoundedRectangle(cornerRadius: 50)
                .stroke(Color.mTintColor, lineWidth: noteTypeSelectionMode ? 2 : 0)
        )
        .cornerRadius(50)
    }


    @ViewBuilder
    private func NoteIconButton(_ note: NoteType,
                                action: @escaping ()->Void) -> some View {
        Button(action: action, label: {
            Image(systemName: note.systemImage)
                .foregroundColor(.secondary)
                .font(.largeTitle)
        })
    }
}

struct
NotesView_Previews: PreviewProvider {
    static var previews: some View {
        NotesView(viewModel: NotesViewModel(userId: " "))
    }
}

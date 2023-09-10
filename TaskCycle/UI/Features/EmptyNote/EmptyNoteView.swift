//
//  EmptyNoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import SwiftUI

enum EmptyNoteFields: String {
    case title
    case description
}

struct EmptyNoteView: View {

    @EnvironmentObject var notesViewModel: NotesViewModel

    @ObservedObject var viewModel: EmptyNoteViewModel

    @FocusState var focusState: EmptyNoteFields?

    var body: some View {
        VStack (alignment: .leading) {
            TextField("Title...", text: $viewModel.note.title)
                .font(.largeTitle).bold()
                .focused($focusState, equals: .title)
                .onSubmit {
                    focusState = .description
                    if viewModel.note.description == EmptyNoteFields.description.rawValue {
                        viewModel.note.description = " "
                    }
                }

            TextField("Write something . . .", text: $viewModel.note.description, axis: .vertical)
                .font(.title2)
                .foregroundColor(.secondary)
                .onSubmit { withAnimation { hideKeyboard() } }
                .focused($focusState, equals: .description)
        }
        .vSpacing(.topLeading)
        .padding()
        .onChange(of: viewModel.note) { _ in
            viewModel.updateNote()
        }
        .onAppear {
            focusState = viewModel.initialFocusState()
        }
        .onDisappear {
            if viewModel.uncompletedNote {
                viewModel.deleteNote()
            } else {
                notesViewModel.fetchNotes()
            }
        }
    }

}

struct EmptyNoteView_Previews: PreviewProvider {

    static let note = NoteModel(id: UUID().uuidString,
                                title: "", description: "",
                                items: [], date: Date().timeIntervalSince1970,
                                noteType: NoteType.empty.rawValue)

    static var previews: some View {
        EmptyNoteBuilder.make(userId: Mock.userId, note: Mock.note)
    }
}

private extension String {
    func placeholder() -> String {
        self.isEmpty ? "Enter ..." : self
    }
}

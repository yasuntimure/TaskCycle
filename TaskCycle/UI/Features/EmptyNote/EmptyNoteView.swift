//
//  EmptyNoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import SwiftUI

enum EmptyNoteFields: String {
    case title
    case description = "Enter here..."
}

struct EmptyNoteView: View {

    @EnvironmentObject var notesViewModel: NotesViewModel

    @ObservedObject var viewModel: EmptyNoteViewModel

    @FocusState var focusState: EmptyNoteFields?

    var placeholderVisible: Bool {
        viewModel.note.description == "Enter here..." && focusState != .description
    }

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

            TextEditor(text: $viewModel.note.description)
                .foregroundColor(.secondary)
                .opacity(placeholderVisible ? 0.5 : 1)
                .font(.title)
                .focused($focusState, equals: .description)
                .onTapGesture {
                    if placeholderVisible {
                        viewModel.note.description = ""
                    }
                }
                .onSubmit {
                    if viewModel.note.description.isEmpty {
                        viewModel.note.description = "Enter here..."
                    }
                }
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
            notesViewModel.fetchNotes()
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

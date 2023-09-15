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

    @ObservedObject var viewModel: EmptyNoteViewModel

    @FocusState var focusState: EmptyNoteFields?

    var body: some View {
        VStack (alignment: .leading) {
            TextField("Title...", text: $viewModel.note.title)
                .font(.largeTitle).bold()
                .focused($focusState, equals: .title)
                .onSubmit { focusState = .description }

            TextField("Write something . . .", text: $viewModel.note.description, axis: .vertical)
                .font(.title2)
                .foregroundColor(.secondary)
                .focused($focusState, equals: .description)
                .vSpacing(.top)
        }
        .vSpacing(.topLeading)
        .padding()
        .toolbarKeyboardDismiss()
        .onChange(of: viewModel.note) { _ in
            viewModel.updateNote()
        }
        .onAppear {
            focusState = viewModel.initialFocusState()
        }
        .onDisappear {
            if viewModel.uncompletedNote {
                viewModel.deleteNote()
            } 
        }
    }

}

struct EmptyNoteView_Previews: PreviewProvider {

    static let note = NoteModel(id: UUID().uuidString,
                                title: "", description: "",
                                items: [], date: Date().weekdayFormat(),
                                noteType: NoteType.empty.rawValue)

    static var previews: some View {
        EmptyNoteView(viewModel: EmptyNoteViewModel(note: note))
    }
}

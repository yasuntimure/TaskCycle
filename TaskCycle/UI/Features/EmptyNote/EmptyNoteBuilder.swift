//
//  EmptyNoteBuilder.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-21.
//

import SwiftUI

struct EmptyNoteBuilder {

    static func make(userId: String, note: NoteModel) -> some View {
        let viewModel = EmptyNoteViewModel(userId: userId, note: note)
        return EmptyNoteView(viewModel: viewModel)
    }
}

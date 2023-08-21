//
//  EmptyNoteBuilder.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-21.
//

import SwiftUI

final class EmptyNoteBuilder {

    static func make(userId: String, note: NoteModel) -> some View {
        let viewModel = EmptyNoteViewModel(userId: userId, note: note)
        return EmptyNoteView(viewModel: viewModel)
    }
}

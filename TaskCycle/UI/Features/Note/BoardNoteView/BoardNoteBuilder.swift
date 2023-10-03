//
//  BoardNoteBuilder.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import SwiftUI

struct BoardNoteBuilder {

    @MainActor
    static func make(id: String) -> some View {
        let service = BoardNoteService(noteId: id)
        let viewModel = BoardNoteViewModel(service: service)
        return BoardNoteView(viewModel: viewModel)
    }
}

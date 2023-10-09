//
//  NoteBuilder.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-17.
//

import SwiftUI

struct NoteBuilder {

    @MainActor
    static func make(_ noteModel: Note, isCardDetail: Bool = false) -> some View {
        let viewModel = NoteViewModel(noteModel, isCardDetail: isCardDetail)
        return NoteView(vm: viewModel)
    }
}

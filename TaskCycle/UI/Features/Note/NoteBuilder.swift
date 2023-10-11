//
//  NoteBuilder.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-17.
//

import SwiftUI

struct NoteBuilder {

    @MainActor
    static func make(_ noteModel: Note) -> some View {
        let viewModel = NoteViewModel(noteModel)
        return NoteView(vm: viewModel)
    }
}

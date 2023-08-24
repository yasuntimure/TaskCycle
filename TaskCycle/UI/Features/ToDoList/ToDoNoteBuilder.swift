//
//  ToDoNoteBuilder.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-21.
//

import SwiftUI

struct ToDoNoteBuilder {

    static func make(userId: String, note: NoteModel) -> some View {
        let viewModel = ToDoNoteViewModel(userId: userId, note: note)
        return ToDoNoteView(viewModel: viewModel)
    }
    
}

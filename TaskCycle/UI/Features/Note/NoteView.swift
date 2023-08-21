//
//  NoteView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-20.
//

import SwiftUI

struct NoteView: View {

    @State var type: NoteType

    @StateObject var viewModel = NoteViewModel()

    var body: some View {
        ZStack {
//            switch type {
//            case .empty:
//                EmptyNoteView()
//            case .todo:
//                EmptyNoteView()
//            case .board:
                BoardNoteView()
//            }
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        NoteView(type: .empty)
    }
}

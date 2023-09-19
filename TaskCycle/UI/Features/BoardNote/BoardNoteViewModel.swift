//
//  BoardNoteViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-16.
//

import SwiftUI
import FirebaseFirestore



@MainActor
class BoardNoteViewModel: ObservableObject {

    @Published var note: NoteModel

    @State var isToDoTargeted: Bool = false
    @State var isInProgressTargeted: Bool = false
    @State var isDoneTargeted: Bool = false

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    init(note: NoteModel) {
        self.note = note
    }


    

}

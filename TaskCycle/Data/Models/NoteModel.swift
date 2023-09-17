//
//  NoteModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import SwiftUI
import FirebaseFirestoreSwift
import EmojiPicker
import UniformTypeIdentifiers

struct NoteModel: FirebaseIdentifiable, Transferable {
    var id: String
    var title: String
    var description: String
    var items: [ToDoItemModel]
    var date: String
    var emoji: String?
    var noteType: String
    var toDoTasks: [NoteModel]
    var inProgressTasks: [NoteModel]
    var doneTasks: [NoteModel]

    init(id: String = UUID().uuidString,
         title: String = "",
         description: String = "",
         items: [ToDoItemModel] = [],
         date: String = Date().weekdayFormat(),
         emoji: String? = nil,
         noteType: String = NoteType.empty.rawValue,
         toDoTasks: [NoteModel] = [],
         inProgressTasks: [NoteModel] = [],
         doneTasks: [NoteModel] = [])
    {
        self.id = id
        self.title = title
        self.description = description
        self.items = items
        self.date = date
        self.emoji = emoji
        self.noteType = noteType
        self.toDoTasks = toDoTasks
        self.inProgressTasks = toDoTasks
        self.doneTasks = toDoTasks
    }

    func type() -> NoteType {
        NoteType(rawValue: noteType) ?? NoteType.empty
    }

    static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation (contentType: .noteModel)
    }
}

extension UTType {
    static let noteModel = UTType(exportedAs: "com.eyupyasuntimur.noteModel")
}

enum NoteType: String, Hashable, CaseIterable {
    case empty, todo, board

    var systemImage: String {
        switch self {
        case .empty:  return "doc.text"
        case .todo: return "checkmark.circle"
        case .board:  return "tablecells"
        }
    }
}

//
//  NoteModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import Foundation
import FirebaseFirestoreSwift
import EmojiPicker

struct NoteModel: FirebaseIdentifiable {
    var id: String
    var title: String
    var description: String
    var items: [ToDoItemModel]
    var date: String
    var emoji: String?
    var noteType: String

    init(id: String = UUID().uuidString,
         title: String = "",
         description: String = "",
         items: [ToDoItemModel] = [],
         date: String = Date().weekdayFormat(),
         emoji: String? = nil,
         noteType: String = NoteType.empty.rawValue)
    {
        self.id = id
        self.title = title
        self.description = description
        self.items = items
        self.date = date
        self.emoji = emoji
        self.noteType = noteType
    }

    func type() -> NoteType {
        NoteType(rawValue: noteType) ?? NoteType.empty
    }
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

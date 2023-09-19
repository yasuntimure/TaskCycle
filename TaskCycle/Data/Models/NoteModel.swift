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
    var noteType: String?
    var kanbanColumns: [KanbanColumn]

    init(id: String = UUID().uuidString,
         title: String = "",
         description: String = "",
         items: [ToDoItemModel] = [],
         date: String = Date().weekdayFormat(),
         emoji: String? = nil,
         noteType: String? = nil,
         kanbanColumns: [KanbanColumn] = [KanbanColumn(title: "To Do"), KanbanColumn(title: "In Progress"), KanbanColumn(title: "Done")])
    {
        self.id = id
        self.title = title
        self.description = description
        self.items = items
        self.date = date
        self.emoji = emoji
        self.noteType = noteType
        self.kanbanColumns = kanbanColumns
    }

    func type() -> NoteType? {
        if let noteType = noteType {
            return NoteType(rawValue: noteType)
        }
        return nil
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

extension NoteModel {

    static func quickNote() -> NoteModel {
        NoteModel(title: "Quick Note", description: "Complete your quick to do list!")
    }
}


class Note: Identifiable {

    @Published var id: String
    @Published var title: String
    @Published var description: String
    @Published var items: [ToDoItemModel]
    @Published var date: String
    @Published var emoji: String?
    @Published var noteType: String?
    @Published var kanbanColumns: [KanbanColumn]

    init(_ noteModel: NoteModel)
    {
        self.id = noteModel.id
        self.title = noteModel.title
        self.description = noteModel.description
        self.items = noteModel.items
        self.date = noteModel.date
        self.emoji = noteModel.emoji
        self.noteType = noteModel.noteType
        self.kanbanColumns = noteModel.kanbanColumns
    }

    func type() -> NoteType? {
        if let noteType = noteType {
            return NoteType(rawValue: noteType)
        }
        return nil
    }

}

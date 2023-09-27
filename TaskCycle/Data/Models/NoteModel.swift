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

public struct NoteModel: FirebaseIdentifiable, Transferable {
    public var id: String
    public var title: String
    public var description: String
    public var items: [ToDoItemModel]
    public var date: String
    public var emoji: String?
    public var noteType: String?
    public var kanbanModels: [KanbanModel]

    init(id: String = UUID().uuidString,
         title: String = "",
         description: String = "",
         items: [ToDoItemModel] = [],
         date: String = Date().weekdayFormat(),
         emoji: String? = nil,
         noteType: String? = nil,
         kanbanColumns: [KanbanModel] = [KanbanModel(title: "To Do"), KanbanModel(title: "In Progress"), KanbanModel(title: "Done")])
    {
        self.id = id
        self.title = title
        self.description = description
        self.items = items
        self.date = date
        self.emoji = emoji
        self.noteType = noteType
        self.kanbanModels = kanbanColumns
    }

    func type() -> NoteType? {
        if let noteType = noteType {
            return NoteType(rawValue: noteType)
        }
        return nil
    }

    public static var transferRepresentation: some TransferRepresentation {
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

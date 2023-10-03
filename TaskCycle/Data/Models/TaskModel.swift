//
//  TaskModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import SwiftUI
import FirebaseFirestoreSwift
import EmojiPicker
import UniformTypeIdentifiers
import FirestoreService

public struct TaskModel: FirestoreIdentifiable, Transferable {
    public var id: String
    public var title: String
    public var description: String
    public var items: [ToDoItemModel]
    public var date: String
    public var emoji: String?
    public var noteType: String?

    init(id: String = UUID().uuidString,
         title: String = "",
         description: String = "",
         items: [ToDoItemModel] = [],
         date: String = Date().weekdayFormat(),
         emoji: String? = nil,
         noteType: String? = nil)
    {
        self.id = id
        self.title = title
        self.description = description
        self.items = items
        self.date = date
        self.emoji = emoji
        self.noteType = noteType
    }

    func type() -> NoteType? {
        if let noteType = noteType {
            return NoteType(rawValue: noteType)
        }
        return nil
    }

    public static var transferRepresentation: some TransferRepresentation {
        CodableRepresentation (contentType: .taskModel)
    }
}

extension UTType {
    static let taskModel = UTType(exportedAs: "com.eyupyasuntimur.taskModel")
}



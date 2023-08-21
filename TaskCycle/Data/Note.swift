//
//  Note.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-19.
//

import Foundation
import FirebaseFirestoreSwift
import EmojiPicker

protocol NoteProtocol {
    var id: String { get }
    var title: String { get set }
    var description: String { get set }
    var items: [ToDoItemModel] { get set }
    var date: TimeInterval { get set }
    var emoji: String? { get set }
    var noteType: String { get set }
}

struct NoteModel: NoteProtocol, Hashable, Codable, Identifiable {
    var id: String
    var title: String
    var description: String
    var items: [ToDoItemModel]
    var date: TimeInterval
    var emoji: String?
    var noteType: String

    func type() -> NoteType {
        NoteType(rawValue: noteType) ?? NoteType.empty
    }
}

enum NoteType: String {
    case empty, todo, board
}

class Note: ObservableObject {

    @Published var id: String = ""
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var items: [ToDoItemModel] = []
    @Published var date: Date = Date()
    @Published var emoji: Emoji?
    @Published var type: NoteType = .empty

    func getStructModel() -> NoteModel {
        NoteModel(id: UUID().uuidString,
                  title: self.title,
                  description: self.description,
                  items: self.items,
                  date: self.date.timeIntervalSince1970,
                  emoji: self.emoji?.value,
                  noteType: self.type.rawValue)
    }

    func reset() {
        self.id = ""
        self.title = ""
        self.description = ""
        self.items = []
        self.date = Date()
        self.emoji = nil
    }
}

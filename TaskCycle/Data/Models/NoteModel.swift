//
//  NoteModel.swift
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

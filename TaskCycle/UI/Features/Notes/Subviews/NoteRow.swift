//
//  NoteRow.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-29.
//

import SwiftUI

struct NoteRow: View {
    @EnvironmentObject var theme: Theme

    @Binding var note: Note

    var body: some View {
        HStack {
            VStack {
                if let emoji = note.emoji {
                    Text(emoji)
                        .font(.largeTitle)
                } else {
                    Image(systemName: note.type()?.systemImage ?? NoteType.empty.systemImage)
                        .font(.largeTitle)
                        .foregroundColor(theme.mTintColor)
                }
            }
            .vSpacing(note.description.isEmpty ? .center : .top)
            .padding(.top, note.description.isEmpty ? 0 : 10)

            VStack (alignment: .leading, spacing: 2) {
                Text(note.title)
                    .font(.headline)

                if !note.description.isEmpty {
                    Text(note.description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                        .lineLimit(3)
                }
            }
            .hSpacing(.leading)
            .vSpacing(.center)
            .padding(.leading, 5)
        }
    }
}

struct NoteRow_Previews: PreviewProvider {
    
    static let todoItemWithDescription = Note(
        id: UUID().uuidString,
        title: "Buy some milk 🥛",
        description: "Get lactose free one Get lactose free one Get lactose free one Get lactose free one Get lactose free one",
        date: Date().weekdayFormat(),
        noteType: NoteType.empty.rawValue
    )

    static let todoItemWithoutDescription = Note(
        id: UUID().uuidString,
        title: "Buy some milk 🥛",
        description: "",
        date: Date().weekdayFormat(),
        noteType: NoteType.empty.rawValue
    )

    static var previews: some View {
        List {
            NoteRow(note: .constant(todoItemWithoutDescription))
                .environmentObject(Theme())
            NoteRow(note: .constant(todoItemWithDescription))
                .environmentObject(Theme())
        }
//        .listRowSpacing(10)

    }
}

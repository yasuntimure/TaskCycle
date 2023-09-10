//
//  NoteRow.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-29.
//

import SwiftUI

struct NoteRow: View {

    @Binding var note: NoteModel

    var body: some View {
        HStack {
            if let emoji = note.emoji {
                Text(emoji)
                    .font(.largeTitle)
                    .vSpacing(.top)
                    .padding(.top, 15)
            } else {
                Image(systemName: "doc.text")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(Color.mTintColor)
                    .vSpacing(.top)
                    .padding(.top, 15)
            }

            VStack (alignment: .leading, spacing: 5) {
                Text(note.title)
                    .font(.headline)

                if !note.description.isEmpty {
                    Text(note.description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.leading, 5)
        }
    }
}

struct NoteRow_Previews: PreviewProvider {
    
    static let todoItemWithDescription = NoteModel(
        id: UUID().uuidString,
        title: "Buy some milk 🥛",
        description: "Get a lactose free one",
        items: [],
        date: Date().timeIntervalSince1970,
        noteType: NoteType.empty.rawValue
    )

    static var previews: some View {
        NoteRow(note: .constant(todoItemWithDescription))
    }
}

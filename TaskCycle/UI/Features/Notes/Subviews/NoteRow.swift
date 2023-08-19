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
            Image(systemName: "doc.text")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)

            VStack (alignment: .leading, spacing: 5) {
                Text(note.title)
                    .font(.headline)


                if !note.description.isEmpty {
                    Text(note.description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                }

            }
            .padding(.leading, 5)

            Spacer()
        }
        .padding(.vertical, 5)
    }
}

struct NoteRow_Previews: PreviewProvider {
    
    static let todoItemWithDescription = NoteModel(
        id: UUID().uuidString,
        title: "Buy some milk 🥛",
        description: "Get a lactose free one",
        items: [],
        date: Date().timeIntervalSince1970
    )

    static var previews: some View {
        NoteRow(note: .constant(todoItemWithDescription))
    }
}

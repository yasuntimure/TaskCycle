//
//  ToDoListItemView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

struct ToDoListItemRow: View {

    @Binding var item: ToDoListItemModel

    var body: some View {
        HStack {
            ToggleButton(state: $item.isDone)
                .frame(width: 30, height: 30)
                .vSpacing(.topLeading)

            VStack (alignment: .leading, spacing: 5) {
                Text(item.title)
                    .font(.headline)
                    .strikethrough(item.isDone)


                if !item.description.isEmpty {
                    Text(item.description)
                        .font(.body)
                        .strikethrough(item.isDone)
                        .multilineTextAlignment(.leading)
                }

            }
            .padding(.leading, 5)

            Spacer()
        }
        .padding(.vertical, 5)
    }
}

struct ToDoItemRow_Previews: PreviewProvider {

    static let todoItemWithDescription = ToDoListItemModel(
        id: UUID().uuidString,
        title: "Buy some milk 🥛",
        description: "Get a lactose free one",
        date: Date().timeIntervalSince1970
    )

    static var previews: some View {
        Group {

            Stateful(value: todoItemWithDescription) { todoItem in
                ToDoListItemRow(item: todoItem)
            }
            .previewDisplayName("With Description")
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}


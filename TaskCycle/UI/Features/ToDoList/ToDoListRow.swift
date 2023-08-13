//
//  EditItemView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-11.
//

import SwiftUI

struct ToDoListRow: View {

    @Binding var item: ToDoListItemModel

    var body: some View {
        HStack (alignment: .top) {

            ToggleButton(state: $item.isDone)
                .frame(width: 30, height: 30)

            VStack (alignment: .leading, spacing: 5) {

                TextField("Title", text: $item.title)
                    .font(.headline)
                    .strikethrough(item.isDone)

                if !item.description.isEmpty {
                    TextEditor(text: $item.description)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .scrollContentBackground(.hidden)
                        .foregroundColor(item.isDone ? .gray.opacity(0.3) : .primary)
                        .strikethrough(item.isDone, color: .primary)
                }

            }
            .padding(.leading, 5)
            .hSpacing(.leading)
        }
        .padding()
        .background(Color.backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(.horizontal)
        .padding(.top, 5)

    }
}

struct EditItemView_Previews: PreviewProvider {

    static let item = ToDoListItemModel(
        id: "",
        title: "Drink Water",
        description: "Remember to drink 3l water everyday .cornerRadius(15)  .cornerRadius(15) .cornerRadius(15)  .cornerRadius(15) .cornerRadius(15) ",
        date: Date().timeIntervalSince1970
    )

    static var previews: some View {
        ToDoListRow(item: .constant(item))
    }
}

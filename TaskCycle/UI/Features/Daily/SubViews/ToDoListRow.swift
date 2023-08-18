//
//  EditItemView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-11.
//

import SwiftUI

struct ToDoListRow: View {

    private enum FocusFields {
        case title, description
    }

    @EnvironmentObject var viewModel: DailyViewModel

    @FocusState private var focusState: FocusFields?

    @State var isNew: Bool
    @Binding var item: ToDoListItemModel

    var body: some View {
        HStack {
            ToggleButton(state: $item.isDone)
                .frame(width: 30, height: 30)

            TextField("Title", text: $item.title)
                .font(.headline)
                .strikethrough(item.isDone)
                .focused($focusState, equals: .title)
                .onSubmit {
                    viewModel.isEditing = false
                    withAnimation { hideKeyboard() }
                }
        }
        .padding()
        .background(Color.backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(.horizontal)
        .padding(.top, 5)
        .onChange(of: item) { newItem in
            isNew = false
            withAnimation {
                viewModel.update(item: newItem)
            }
        }
        .onAppear {
            focusState = isNew ? .title : nil
        }
    }
    
//    @ViewBuilder
//    private func Description() -> some View {
//        TextEditor(text: $item.description)
//            .font(.body)
//            .multilineTextAlignment(.leading)
//            .scrollContentBackground(.hidden)
//            .foregroundColor(item.isDone ? .gray.opacity(0.3) : .primary)
//            .foregroundColor(item.isDone ? .gray.opacity(0.3) : .primary)
//            .strikethrough(item.isDone, color: .primary)
//    }

}

struct EditItemView_Previews: PreviewProvider {

    static let item = ToDoListItemModel(
        id: "",
        title: "Drink Water",
        description: "Remember to drink 3l water everyday .cornerRadius(15)  .cornerRadius(15) .cornerRadius(15)  .cornerRadius(15) .cornerRadius(15) ",
        date: Date().timeIntervalSince1970
    )

    static var previews: some View {
        ToDoListRow(isNew: true, item: .constant(item))
    }
}

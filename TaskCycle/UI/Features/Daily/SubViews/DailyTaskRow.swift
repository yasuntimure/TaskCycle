//
//  DailyTaskRow.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-11.
//

import SwiftUI

struct DailyTaskRow: View {

    private enum FocusFields {
        case title, description
    }

    @EnvironmentObject var viewModel: DailyViewModel

    @FocusState private var focusState: FocusFields?

    @Binding var item: ToDoItemModel

    var body: some View {
        HStack {
            ToggleButton(state: $item.isDone)
                .frame(width: 30, height: 30)

            TextField("Write something . . .", text: $item.title)
                .font(.headline)
                .strikethrough(item.isDone)
                .focused($focusState, equals: .title)
                .onSubmit { withAnimation { hideKeyboard() } }
        }
        .padding()
        .background(Color.backgroundColor)
        .cornerRadius(15)
        .shadow(radius: 2)
        .padding(.horizontal)
        .padding(.top, 5)
        .onChange(of: item) { newItem in
            withAnimation {
                viewModel.update(item: newItem)
            }
        }
        .onAppear {
            focusState = item.title.isEmpty ? .title : nil
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

struct DailyTaskRow_Previews: PreviewProvider {

    static let item = ToDoItemModel(
        id: "",
        title: "Drink Water",
        description: "Remember to drink 3l water everyday .cornerRadius(15)  .cornerRadius(15) .cornerRadius(15)  .cornerRadius(15) .cornerRadius(15) ",
        date: Date().timeIntervalSince1970
    )

    static var previews: some View {
        DailyTaskRow(item: .constant(item))
            .environmentObject(DailyViewModel(userId: "5JK0lwRArPULkWLO6Xf9DPxdo073"))
    }
}

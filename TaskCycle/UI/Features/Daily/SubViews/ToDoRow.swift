//
//  DailyTaskRow.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-11.
//

import SwiftUI

struct ToDoRow: View {
    @EnvironmentObject var theme: Theme

    @Binding var item: ToDoItem
    @FocusState var isFocused: Bool?

    var body: some View {
        HStack (spacing: 0) {
            Button {
                item.isDone.toggle()
            } label: {
                ToggleButton()
            }

            TextField("Write something . . .", text: $item.title, axis: .vertical)
                .font(.headline)
                .strikethrough(item.isDone)
                .focused($isFocused, equals: true)
                .padding([.vertical, .trailing])
        }
        .layeredBackground(Color.backgroundColor)
        .cornerRadius(20)
        .onAppear {
            isFocused = item.title.isEmpty
        }
    }

    @ViewBuilder
    private func ToggleButton() -> some View {
        ZStack (alignment: .center) {
            // Empty Circle
            Circle()
                .fill(item.isDone ? theme.mTintColor : .clear)
                .stroke(theme.mTintColor, lineWidth: 2)
            // Checked Circle
            if item.isDone {
                Image(systemName: "checkmark")
                    .foregroundColor(.white)
                    .font(.subheadline)
                    .bold()
            }
        }
        .frame(width: 30, height: 30)
        .padding()
    }
}

struct ToDoRow_Previews: PreviewProvider {

    static let item = ToDoItem(title: "Drink Water")

    static var previews: some View {
        Stateful(value: item) { $item in
            ToDoRow(item: $item)
                .environmentObject(Theme())
                .padding()
        }

    }
}

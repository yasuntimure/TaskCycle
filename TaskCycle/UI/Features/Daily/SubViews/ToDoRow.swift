//
//  DailyTaskRow.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-11.
//

import SwiftUI

struct ToDoRow: View {
    @EnvironmentObject var theme: Theme

    @Binding var item: ToDoItemModel
    @FocusState var isFocused: Bool

    var body: some View {
        HStack (spacing: 0) {
            ToggleButton()
                .frame(width: 30, height: 30)
                .padding()

            TextField("Write something . . .", text: $item.title, axis: .vertical)
                .font(.headline)
                .strikethrough(item.isDone)
                .focused($isFocused)
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
        Button {
            item.isDone.toggle()
        } label: {
            ZStack (alignment: .center) {
                // Empty Circle
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(theme.mTintColor)
                // Checked Circle
                if item.isDone {
                    GeometryReader { proxy in
                        ZStack {
                            Circle()
                                .foregroundColor(theme.mTintColor)
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: proxy.size.width/2))
                                .bold()
                        }
                    }
                    .scaledToFit()
                }
            }
        }
    }
}

struct ToDoRow_Previews: PreviewProvider {

    static let item = ToDoItemModel(title: "Drink Water")

    static var previews: some View {
        ToDoRow(item: .constant(item))
            .environmentObject(Theme())
    }
}

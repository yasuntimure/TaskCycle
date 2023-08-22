//
//  DailyTaskRow.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-11.
//

import SwiftUI

struct ToDoRow: View {

    @Binding var item: ToDoItemModel

    var body: some View {
        HStack (spacing: 12) {
            ToggleButton()
                .frame(width: 30, height: 30)

            TextField("Write something . . .", text: $item.title)
                .font(.headline)
                .strikethrough(item.isDone)
                .onSubmit { withAnimation { hideKeyboard() } }
        }
        .padding()
        .frame(height: 60)
        .background(Color.backgroundColor)
        .cornerRadius(20)
        .shadow(radius: 2)
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
                    .foregroundColor(.mTintColor)
                // Checked Circle
                if item.isDone {
                    GeometryReader { proxy in
                        ZStack {
                            Circle()
                                .foregroundColor(.mTintColor)
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

    static let item = ToDoItemModel(id: "", title: "Drink Water", description: "", date: Date().timeIntervalSince1970)

    static var previews: some View {
        ToDoRow(item: .constant(item))
    }
}

//
//  PlaceholderToDoRow.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-09.
//

import SwiftUI

struct PlaceholderToDoRow: View {

     @State private var title: String = ""

    var body: some View {
        HStack (spacing: 12) {
            ToggleButton(state: .constant(false))
                .frame(width: 30, height: 30)

            TextField("Write something . . .", text: $title)
                .font(.headline)
        }
        .padding()
        .frame(height: 60)
        .background(Color.backgroundColor)
        .cornerRadius(20)
        .opacity(0.5)
        .listRowSeparator(.hidden)
    }
}

#Preview {
    PlaceholderToDoRow()
}

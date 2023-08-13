//
//  HeaderView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-11.
//

import SwiftUI

struct HeaderView: View {

    @Environment (\.colorScheme) var colorScheme: ColorScheme

    var body: some View {

        VStack (alignment: .leading, spacing: 30) {
            HStack (spacing: 5) {
                Text("Task")
                    .font(.system(size: 52)).bold()
                    .foregroundColor(.gray)

                Text("/")
                    .font(.system(size: 32)).bold()
                    .foregroundColor(.black)

                Text("Cycle")
                    .font(.system(size: 52)).bold()
                    .foregroundColor(.mTintColor)
            }
        }
        .hSpacing(.leading).padding(.leading, 30)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}

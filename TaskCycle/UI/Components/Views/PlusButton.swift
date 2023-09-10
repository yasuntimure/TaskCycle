//
//  ButtonView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-18.
//

import SwiftUI

struct PlusButton: View {

    @Environment (\.colorScheme) var color: ColorScheme

    var size: CGFloat = 25

    @State var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack (alignment: .center) {
                Circle()
                    .stroke(lineWidth: size/6)
                    .foregroundColor(.mTintColor)
                    .frame(width: size * 2,
                           height: size * 2)
//                Circle()
//                    .foregroundColor(color == .light ? .white : .black)
//                    .frame(width: size * 1.9,
//                           height: size * 1.9)

                Rectangle()
                    .foregroundColor(.mTintColor)
                    .frame(width: size/6,
                           height: size)
                    .cornerRadius(5)

                Rectangle()
                    .foregroundColor(.mTintColor)
                    .frame(width: size,
                           height: size/6)
                    .cornerRadius(5)
            }
        }
    }
}

struct PlusButton_Previews: PreviewProvider {
    static var previews: some View {
        PlusButton {}
            .previewLayout(.fixed(width: 50, height: 50))
    }
}

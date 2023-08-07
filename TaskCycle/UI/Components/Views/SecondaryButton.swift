//
//  SecondaryButton.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-23.
//

import SwiftUI

struct SecondaryButton: View {

    @Environment (\.colorScheme) var color

    @State var title: String
    @State var width: CGFloat = ScreenSize.width/4
    @State var height: CGFloat = ScreenSize.width/8
    @State var action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack (alignment: .center) {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundColor(.primary)
                    .overlay {
                        RoundedRectangle(cornerSize: size())
                            .stroke(Color.primary, lineWidth: 2)
                    }

                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(color == .light ? .white : .black)
                    .bold()
            }
            .padding(.top)
            .frame(width: width,
                   height: height)
        }
    }

    private func size() -> CGSize {
        CGSize(width: width, height: height)
    }

}

struct SecondaryButton_Previews: PreviewProvider {
    static var previews: some View {
        SecondaryButton(title: "Secondary") { }
    }
}

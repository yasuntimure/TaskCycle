//
//  ButtonView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-12.
//

import SwiftUI

struct PrimaryButton: View {
    @EnvironmentObject var theme: Theme

    @State var title: String
    @State var width: CGFloat = ScreenSize.defaultWidth
    @State var height: CGFloat = 50
    @State var action: () -> Void

    var cornerRadius: CGFloat = 20
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(width: width, height: height)
                .foregroundColor(.white)
                .font(.system(size: 20)).bold()
                .layeredBackground(theme.mTintColor)
                .cornerRadius(cornerRadius)
        }
    }

}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Login") {
            // action
        }
        .environmentObject(Theme())
    }
}

extension View {
    func layeredBackground(_ color: Color = .clear, cornerRadius: CGFloat = 20) -> some View {
        self.background(
            ZStack {
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(color.shadow(
                        .inner(color: .black.opacity(0.04), radius: 1, x: -2, y: -2))
                    )
            }

        )
    }
}

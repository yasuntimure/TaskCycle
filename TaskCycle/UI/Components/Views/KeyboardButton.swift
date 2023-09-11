//
//  KeyboardButton.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-11.
//

import SwiftUI

struct KeyboardButton: View {
    @EnvironmentObject var theme: Theme

    @Environment (\.colorScheme) var color: ColorScheme
    var size: CGFloat = 20
    @State var action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "keyboard.chevron.compact.down.fill")
                .resizable()
                .frame(width: size*2, height: size*2)
                .foregroundColor(theme.mTintColor)
        }
    }
}

struct KeyboardButton_Previews: PreviewProvider {
    static var previews: some View {
        KeyboardButton {
        }
        .environmentObject(Theme())
    }
}

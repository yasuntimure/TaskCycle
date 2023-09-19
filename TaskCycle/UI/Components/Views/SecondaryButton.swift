//
//  SecondaryButton.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-17.
//

import SwiftUI

struct SecondaryButton: View {

    @State var imageName: String?
    @State var imageFont: Font = .headline
    @State var imageColor: Color = .black.opacity(0.6)

    @State var title: String
    @State var titleFont: Font = .headline
    @State var titleColor: Color = .black.opacity(0.6)

    @State var innerVerticalPadding: CGFloat = 10
    @State var backgroundColor: Color = .blue.opacity(0.15)
    @State var cornerRadius: CGFloat = 8

    @State var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 2) {
                if let name = imageName {
                    Image(systemName: name)
                        .font(imageFont)
                }
                Text(title)
                    .font(titleFont)
                    .lineLimit(1)
            }
            .foregroundStyle(imageColor)
            .hSpacing(.center)
            .padding(.vertical, innerVerticalPadding)
            .layeredBackground(backgroundColor, cornerRadius: cornerRadius)
        }
    }
}

#Preview {
    SecondaryButton(title: "") {
        // TODO: ..
    }
}

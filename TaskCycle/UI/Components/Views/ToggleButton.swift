//
//  ToggleButton.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-19.
//

import SwiftUI

struct ToggleButton: View {

    @Binding var state: Bool

    var body: some View {
        Button {
            state.toggle()
        } label: {
            ZStack (alignment: .center) {

                // Empty Circle
                Circle()
                    .stroke(lineWidth: 2)
                    .foregroundColor(.mTintColor)

                // Checked Circle
                if state {
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


// MARK: - Checked Circle

extension ToggleButton {
    var CheckedCircle: some View {
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


// MARK: - Preview

struct ToggleButtonView_Previews: PreviewProvider {

    static var isChecked: Bool = false

    static var previews: some View {
        Stateful(value: isChecked) { isChecked in
            ToggleButton(state: isChecked)
        }
            .previewLayout(.fixed(width: 100, height: 100))
    }
}

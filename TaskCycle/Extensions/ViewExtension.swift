//
//  ViewExtension.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-07.
//

import SwiftUI

// Custom View Extensions
extension View {

    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }

    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }

    @ViewBuilder
    func fillIninity(_ alignment: Alignment = .center) -> some View {
        self
            .frame(width: .infinity, height: .infinity, alignment: alignment)
    }

    @ViewBuilder
    func toolbarKeyboardDismiss() -> some View {
        self.toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: { hideKeyboard() },
                       label: { Image(systemName: "keyboard.chevron.compact.down.fill")
                        .font(.headline)
                        .tint(.secondary) })
            }
        }
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif

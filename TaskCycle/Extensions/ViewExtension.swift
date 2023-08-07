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

}

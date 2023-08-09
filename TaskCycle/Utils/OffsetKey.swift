//
//  OffsetKey.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-09.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

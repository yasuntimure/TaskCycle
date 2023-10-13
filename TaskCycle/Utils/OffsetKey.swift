//
//  OffsetKey.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-09
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

struct ShowErrorEnvironmentKey: EnvironmentKey {
    static var defaultValue: (Error, String) -> Void = { _,_ in }
}

extension EnvironmentValues {
    var showError: (Error, String) -> Void {
        get { self [ShowErrorEnvironmentKey.self] }
        set { self [ShowErrorEnvironmentKey.self] = newValue }
    }
}

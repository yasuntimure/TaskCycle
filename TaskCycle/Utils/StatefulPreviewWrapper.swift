//
//  PerviewWrapper.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-18.
//

import SwiftUI

extension PreviewProvider {

    /// Assign a value as binding. The state is internally preserved, enabling to use stateful values into the preview.
    /// - Parameters:
    ///   - value: A value type.
    ///   - content: A block that return a `View`. The block will provide a `Binding<Value>` as parameter.
    /// - Returns: A stateful view that can be used in preview.
    static func Stateful<Value, Content: View>(value: Value, @ViewBuilder content: @escaping(Binding<Value>) -> Content) -> some View {
        StatefulPreviewWrapper(value, content: content)
    }
}

@available(iOS 17.0, *)
extension Preview {

    /// Assign a value as binding. The state is internally preserved, enabling to use stateful values into the preview.
    /// - Parameters:
    ///   - value: A value type.
    ///   - content: A block that return a `View`. The block will provide a `Binding<Value>` as parameter.
    /// - Returns: A stateful view that can be used in preview.
    static func Stateful<Value, Content: View>(value: Value, @ViewBuilder content: @escaping(Binding<Value>) -> Content) -> some View {
        StatefulPreviewWrapper(value, content: content)
    }
}

fileprivate struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content

    var body: some View {
        content($value)
    }

    init(_ value: Value, content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}

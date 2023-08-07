//
//  PreferenceKeyExtension.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-31.
//

import SwiftUI

struct UserIdPreferenceKey: PreferenceKey {
    static let defaultValue: String = ""

    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}

extension View {
    func userId(_ id: String) -> some View {
        self.preference(key: UserIdPreferenceKey.self, value: id)
    }

    func onUserIdChange(_ completion: @escaping (String) -> Void) -> some View {
        self.onPreferenceChange(UserIdPreferenceKey.self) { newUserId in
            completion(newUserId)
        }
    }
}

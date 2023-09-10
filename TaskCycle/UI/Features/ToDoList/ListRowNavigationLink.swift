//
//  ListRowNavigationLink.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-09.
//

import SwiftUI

struct ListRowNavigationLink: ViewModifier {
    let value: any Hashable
    func body(content: Content) -> some View {
        content
            .overlay {
                NavigationLink(value: value) {
                    EmptyView()
                }
                .opacity(0)
            }
    }
}


extension View {
    func listRowNavigationLink(value: any Hashable) -> some View {
        modifier(ListRowNavigationLink(value: value))
    }
}

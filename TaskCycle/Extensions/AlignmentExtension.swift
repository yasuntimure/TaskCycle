//
//  Extension+Alignment.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-18.
//

import SwiftUI

extension VerticalAlignment {
    enum AccountAndName: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat {
            d[.top]
        }
    }

    static let accountAndName = VerticalAlignment(AccountAndName.self)
}

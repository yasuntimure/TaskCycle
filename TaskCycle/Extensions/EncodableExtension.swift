//
//  Encodable+Extension.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-16.
//

import Foundation

typealias Dictionary = [String: Any]

extension Encodable {

    func asDictionary() -> Dictionary {

        guard let data = try? JSONEncoder().encode(self) else {
            return [:]
        }

        guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? Dictionary else {
            return [:]
        }

        return dictionary
    }
}

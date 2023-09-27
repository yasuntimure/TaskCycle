//
//  FirebaseIdentifiable.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-12.
//

import Foundation

public protocol FirebaseIdentifiable: Hashable, Codable, Identifiable {
    var id: String { get set }
}

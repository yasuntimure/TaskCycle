//
//  FirebaseIdentifiable.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-12.
//

import Foundation

protocol FirebaseIdentifiable: Hashable, Codable, Identifiable {
    var id: String { get set }
}

extension FirebaseIdentifiable {
    /// POST to Firebase
    func post(to collection: String) async -> Result<Self, Error> {
        return await FirebaseService.shared.post(self, to: collection)
    }

    /// PUT to Firebase
    func put(to collection: String) async -> Result<Self, Error> {
        return await FirebaseService.shared.put(self, to: collection)
    }
}

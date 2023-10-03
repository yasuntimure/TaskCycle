//
//  FirestoreEndpointExtension.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-10-02.
//

import SwiftKeychainWrapper
import FirestoreService

extension FirestoreEndpoint {
    public var userID: String {
        return KeychainWrapper.standard.string(forKey: "userIdKey") ?? "userIdIsEmpty"
    }
}

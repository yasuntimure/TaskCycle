//
//  User.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

class User {
    let id: String
    let name: String
    let email: String
    let password: String
    let joinDate: TimeInterval

    init(id: String, name: String, email: String, password: String, joinDate: TimeInterval) {
        self.id = id
        self.name = name
        self.email = email
        self.password = password
        self.joinDate = joinDate
    }
}

struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
    let password: String
    let joinDate: TimeInterval
}



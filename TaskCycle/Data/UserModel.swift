//
//  User.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

class User: ObservableObject {
   @Published var id: String = ""
   @Published var name: String = ""
   @Published var email: String = ""
}

struct UserModel: Codable {
    let id: String
    let name: String
    let email: String
    let password: String
    let joinDate: TimeInterval
}



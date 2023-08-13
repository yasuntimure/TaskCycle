//
//  SettingsViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-12.
//

import SwiftUI
import FirebaseAuth

class SettingsViewModel: ObservableObject {

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var userName: String = "Eyup Yasuntimur"
    @Published var joinDate: String = "22.07.2023"
    @Published var userId: String = ""

    func logout(completion: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            showAlert = true
            errorMessage = signOutError.description
        }

        completion()
    }

}

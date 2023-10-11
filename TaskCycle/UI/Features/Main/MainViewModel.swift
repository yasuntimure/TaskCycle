//
//  MainViewModel.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-17.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import SwiftKeychainWrapper

@MainActor
class MainViewModel: ObservableObject {

    @Published var userLoggedIn: Bool = false

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { _, user in
            guard let userId = user?.uid else { return }
            KeychainWrapper.standard.set(userId, forKey: "userIdKey")
            self.userLoggedIn = true

            if let email = user?.email {
                KeychainWrapper.standard.set(email, forKey: "userEmail")
            }
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            showAlert = true
            errorMessage = signOutError.description
        }

        KeychainWrapper.standard.removeObject(forKey: "userIdKey")
        userLoggedIn = false
    }

}

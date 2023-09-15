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
    
    @Published var userId: String = "" 

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let user = user else { return }
            self?.userId = user.uid
            KeychainWrapper.standard.set(user.uid, forKey: "userIdKey")
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
        userId = ""
    }
}

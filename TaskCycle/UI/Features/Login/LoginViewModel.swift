//
//  LoginViewModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import Foundation
import FirebaseAuth
import Firebase
import GoogleSignIn
import SwiftUI
import Combine

@MainActor
class LoginViewModel: ObservableObject {

    private var subscription = Set<AnyCancellable>()

    @Published var email: InputField = InputField(placeholder: "Enter Email", text: "", validation: Validation.none)
    @Published var password: InputField = InputField(placeholder: "Enter Password", text: "", validation: Validation.none)

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var isRegisterPresented = false

    init() {
        $email
            .dropFirst(4)
            .sink { email in
                if email.text.count > 3 {
                    self.validateEmail()
                }
        }.store(in: &subscription)

        $password
            .dropFirst(4)
            .sink { password in
                if password.text.count > 5 {
                    self.validatePassword()
                }
        }.store(in: &subscription)
    }

    func login() {
        validateEmail()
        validatePassword()
        guard email.validation == .email(.approved) && password.validation == .password(.approved) else {
            self.showAlert(message: "Email or Password not approved!")
            return
        }
        signIn(withEmail: email.text, password: password.text)
    }

    func signInWithGoogle() {
        // Create Google Sign In configuration object.
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config

        // Prepare presenting viewController
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        guard let rootViewController = window?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { [weak self] signInResult, error in
            if let error = error {
                self?.showAlert(message: "\(error.localizedDescription)")
            }

            guard let email = signInResult?.user.profile?.email,
                    let password = signInResult?.user.userID else {
                self?.showAlert(message: "An error occured while fetching data from google!")
                return
            }

            self?.signIn(withEmail: email, password: password)
        }
    }

    internal func signIn(withEmail: String, password: String) {
        Auth.auth().signIn(withEmail: withEmail, password: password) { [weak self] result, error in
            guard let user = result?.user, error == nil else {
                self?.showAlert(message: error?.localizedDescription ?? "Could not create a new account!")
                return
            }
            let displayName = user.displayName ?? "user"
            print("Success: \(displayName) logged in")
        }
    }

    private func showAlert(message: String) {
        errorMessage = message
        showAlert = true
    }
}


// MARK: - Validation

extension LoginViewModel {
    
    func validateEmail() {

        guard !email.text.trimmingCharacters(in: .whitespaces).isEmpty else {
            email.validation = .email(.empty)
            return
        }

        guard email.text.contains("@") && email.text.contains(".") else {
            email.validation = .email(.invalid)
            return
        }

        email.validation = .email(.approved)
    }
    
    func validatePassword() {

        guard !password.text.trimmingCharacters(in: .whitespaces).isEmpty else {
            password.validation = .password(.empty)
            return
        }

        guard password.text.count < 64 && password.text.count >= 6 else {
            password.validation = .password(.invalid)
            return
        }

        password.validation = .password(.approved)
    }
}



enum ValidationStatus: String {
    case approved = "Approved!"
    case empty = "is empty!"
    case invalid = "is invalid!"
    case notMatching = "is not matching!"
}
    

enum Validation: Equatable {
    case name(ValidationStatus)
    case email(ValidationStatus)
    case password(ValidationStatus)
    case confirm_password(ValidationStatus)
    case none
    
    func status() -> ValidationStatus {
        switch self {
        case .name(let validationStatus):
            return validationStatus
        case .email(let validationStatus):
            return validationStatus
        case .password(let validationStatus):
            return validationStatus
        case .confirm_password(let validationStatus):
            return validationStatus
        case .none:
            return .approved
        }
    }
    
    func message() -> String {
        switch self {
        case .name(let validationStatus):
            return "Name" + " " + validationStatus.rawValue
        case .email(let validationStatus):
            return "Email" + " " + validationStatus.rawValue
        case .password(let validationStatus):
            return "Password" + " " + validationStatus.rawValue
        case .confirm_password(let validationStatus):
            return "Confirmation Password" + " " + validationStatus.rawValue
        case .none:
            return " "
        }
    }
}


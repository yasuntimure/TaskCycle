//
//  LoginViewModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import Foundation
import Firebase
import SwiftUI
import Combine

class LoginViewModel: ObservableObject {

    private var subscription = Set<AnyCancellable>()

    @Published var email: InputField = InputField(placeholder: "Enter Email", text: "", validation: Validation.none)
    @Published var password: InputField = InputField(placeholder: "Enter Password", text: "", validation: Validation.none)
    @Published var isRegisterPresented = false
    @Published var userId: String = ""

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

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
        
        guard email.validation == .email(.approved) && password.validation == .password(.approved) else { return }
            
        // Try Login
        Auth.auth().signIn(withEmail: email.text, password: password.text) { [weak self] result, error in
        
            guard let userId = result?.user.uid, error == nil else {
                print("Error: \(error!.localizedDescription)")
                self?.errorMessage = error?.localizedDescription ?? "Could not create a new account!"
                self?.showAlert = true
                return
            }

            self?.userId = userId
        }
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


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

protocol LoginViewModelProtocol: ObservableObject {
    var email: InputField { get set }
    var password: InputField { get set }
    var userId: String { get set }
    var userName: String { get set }
    var isLoggedIn: Bool { get set }
    var showAlert: Bool { get set }
    var errorMessage: String { get set }
    var isRegisterPresented: Bool { get set }
    func login()
    func signInWithGoogle()
}

class LoginViewModel: LoginViewModelProtocol {

    private var subscription = Set<AnyCancellable>()

    @Published var email: InputField = InputField(placeholder: "Enter Email", text: "", validation: Validation.none)
    @Published var password: InputField = InputField(placeholder: "Enter Password", text: "", validation: Validation.none)

    @Published var userId: String = ""
    @Published var userName: String = ""
    @Published var isLoggedIn: Bool = false

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var isRegisterPresented = false

    init() {
        checkPreviousSignIn()
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

    func checkPreviousSignIn() {
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }

            guard let userId = user?.userID else { return }
            self.userId = userId
        }
    }

    func signInWithGoogle() {
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }

        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)

        GIDSignIn.sharedInstance.configuration = config

        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        let window = windowScenes?.windows.first
        guard let rootViewController = window?.rootViewController else { return }

        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { signInResult, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
                self.showAlert = true
            }

            guard let userId = signInResult?.user.userID else { return }
            self.userId = userId
        }
    }

    func signOut(){
        GIDSignIn.sharedInstance.signOut()
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


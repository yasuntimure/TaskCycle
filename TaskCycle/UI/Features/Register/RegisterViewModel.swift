//
//  RegisterViewModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import Foundation
import Firebase
import FirebaseFirestore
import Combine
import GoogleSignIn
import SwiftKeychainWrapper

@MainActor
class RegisterViewModel: ObservableObject {

    private var subscription = Set<AnyCancellable>()

    @Published var inputs: RegistrationFields = RegistrationFields()

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""
    
    init() {
        inputs.$name
            .dropFirst(4)
            .sink { name in
                if name.text.count > 2 {
                    self.inputs.validateName()
                }

        }.store(in: &subscription)

        inputs.$email
            .dropFirst(4)
            .sink { email in
                if email.text.count > 3 {
                    self.inputs.validateEmail()
                }
        }.store(in: &subscription)

        inputs.$password
            .dropFirst(4)
            .sink { password in
                if password.text.count > 5 {
                    self.inputs.validatePassword()
                }
        }.store(in: &subscription)

        inputs.$confirmPassword
            .dropFirst(4)
            .sink { confPassword in
                if confPassword.text.count > 5 {
                    self.inputs.validateConfirmationPassword()
                }
        }.store(in: &subscription)
    }
    
    func register(_ completion: @escaping () -> Void) {

        guard inputs.areValid() else {
           return
        }

        let name = self.inputs.name.text
        let email = self.inputs.email.text
        let password = self.inputs.password.text

        self.createUser(withEmail: email, password: password) { [weak self] userId in
            let newUser = User (
                id: userId,
                name: name,
                email: email,
                password: password,
                joinDate: Date().timeIntervalSince1970
            )

            self?.insertUserToFirestore(newUser)
            completion()
        }
    }

    func signUpWithGoogle(completion: @escaping () -> Void) {

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

            guard let user = signInResult?.user else { return }

            guard let name = user.profile?.givenName,
                    let email = user.profile?.email,
                    let password = user.userID else {
                self?.showAlert(message: "An error occured while fetching data from google!")
                return
            }

            self?.createUser(withEmail: email, password: password) { [weak self] userId in
                let newUser = User (
                    id: userId,
                    name: name,
                    email: email,
                    password: password,
                    joinDate: Date().timeIntervalSince1970
                )

                self?.insertUserToFirestore(newUser)
                completion()
            }
        }
    }

    private func createUser(withEmail: String, password: String, completion: @escaping (String) -> Void) {
        Auth.auth().createUser(withEmail: withEmail, password: password) { [weak self] result, error in
            guard let userId = result?.user.uid, error == nil else {
                self?.showAlert(message: error?.localizedDescription ?? "Could not create a new account!")
                return
            }
            KeychainWrapper.standard.set(userId, forKey: "userIdKey")
            completion(userId)
        }
    }

    private func insertUserToFirestore(_ user: User) {
        Firestore.firestore().collection("users")
            .document(user.id)
            .setData(user.asDictionary())
    }

    private func showAlert(message: String) {
        errorMessage = message
        showAlert = true
    }
}


// MARK: - RegistrationFields

class RegistrationFields: ObservableObject {

    @Published var name: InputField = InputField(placeholder: "Enter Name")
    @Published var email: InputField = InputField(placeholder: "Enter Email")
    @Published var password: InputField = InputField(placeholder: "Enter Password")
    @Published var confirmPassword: InputField = InputField(placeholder: "Confirm Password")

    func areValid() -> Bool {
        validateName()
        validateEmail()
        validatePassword()
        validateConfirmationPassword()

        guard self.name.validation == .name(.approved) &&
                self.email.validation == .email(.approved) &&
                self.password.validation == .password(.approved) &&
                self.confirmPassword.validation == .confirm_password(.approved) else { return false }

        return true
    }

    func validateName() {
        guard !name.text.trimmingCharacters(in: .whitespaces).isEmpty else {
            name.validation = .name(.empty)
            return
        }
        name.validation = .name(.approved)
    }

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

    func validateConfirmationPassword() {
        guard !confirmPassword.text.trimmingCharacters(in: .whitespaces).isEmpty else {
            confirmPassword.validation = .confirm_password(.empty)
            return
        }

        guard confirmPassword.text == password.text else {
            confirmPassword.validation = .confirm_password(.invalid)
            return
        }

        confirmPassword.validation = .confirm_password(.approved)
    }
}



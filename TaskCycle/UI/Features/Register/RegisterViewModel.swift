//
//  RegisterViewModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import Foundation
import Firebase
import Combine

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

        Auth.auth().createUser(withEmail: inputs.email.text, password: inputs.password.text) { [weak self] result, error in
            guard let userId = result?.user.uid, error == nil else {
                self?.errorMessage = error?.localizedDescription ?? "Could not create a new account!"
                self?.showAlert = true
                return
            }
            
            self?.insertUserId(userId)
            completion()
        }
    }

    func insertUserId(_ userId: String) {
        let newUser = UserModel (
            id: userId,
            name: inputs.name.text,
            email: inputs.email.text,
            password: inputs.password.text,
            joinDate: Date().timeIntervalSince1970
        )

        let database = Firestore.firestore()

        database.collection("users")
            .document(userId)
            .setData(newUser.asDictionary())
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



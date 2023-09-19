//
//  RegisterView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-12.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var theme: Theme

    @StateObject var viewModel = RegisterViewModel()
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {

            GradientView()

            VStack (spacing: 30) {

                VStack (alignment: .leading, spacing: 5) {
                    Text("Register")
                        .font(.system(size: 45)).bold()
                        .foregroundColor(theme.mTintColor)
                    Text("Create a new Account!")
                        .font(.system(size: 30)).bold()
                        .foregroundColor(Color.secondary)
                }
                .hSpacing(.leading)
                .padding(.horizontal)
                .frame(maxWidth: Constants.buttonMaxWidth)

                VStack (spacing: 10) {
                    TextFieldView(input: $viewModel.inputs.name)
                    TextFieldView(input: $viewModel.inputs.email)
                    TextFieldView(input: $viewModel.inputs.password, isSecure: true)
                    TextFieldView(input: $viewModel.inputs.confirmPassword, isSecure: true)
                }

                PrimaryButton(title: "Register") {
                    viewModel.register { dismiss() }
                }

                SeperatorView()

                // Sign In with Google
                SignInWithButton(signInType: .google) {
                    viewModel.signUpWithGoogle { dismiss() }
                }
                .padding(.bottom, 100)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.errorMessage))
            }

        }
    }

    @ViewBuilder
    private func SeperatorView() -> some View {
        HStack (spacing: 12) {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 1.5)
                .foregroundColor(.secondary)
                .opacity(0.5)
                .padding(.leading, 30)
            Text("with")
                .font(.system(size: 16)).bold()
                .foregroundColor(.secondary)
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 1.5)
                .foregroundColor(.secondary)
                .opacity(0.5)
                .padding(.trailing, 30)
        }
        .frame(maxWidth: Constants.buttonMaxWidth)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(Theme())
    }
}

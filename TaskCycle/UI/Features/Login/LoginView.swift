//
//  LoginView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI
import Firebase
import GoogleSignIn
import GoogleSignInSwift

struct LoginView: View {
    @EnvironmentObject var theme: Theme

    private enum Fields {
        case email, password
    }

    @ObservedObject var viewModel: LoginViewModel

    @FocusState private var focusedField: Fields?

    var body: some View {

        ZStack {
            
            GradientView()
            
            VStack {

                HeaderView()

                Text("Sign In")
                    .font(.system(size: 32)).bold()
                    .foregroundColor(.secondary)
                    .hSpacing(.leading)
                    .padding([.leading], 30)
                    .padding(.top)

                TextFieldView(input: $viewModel.email)
                    .frame(width: ScreenSize.defaultWidth)
                    .focused($focusedField, equals: .email)
                    .onSubmit(of: .text) {
                        focusedField = (focusedField == .email) ? .password : nil
                    }

                TextFieldView(input: $viewModel.password, isSecure: true)
                    .frame(width: ScreenSize.defaultWidth)
                    .focused($focusedField, equals: .password)

                PrimaryButton(title: "Login") {
                    viewModel.login()
                }
                .padding(.top, ScreenSize.width/12)

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
                .padding([.top, .bottom], ScreenSize.width/20)

                // Sign In with Google

                SignInWithButton(signInType: .google) {
                    viewModel.signInWithGoogle()
                }

                .padding([.bottom], ScreenSize.width/10)

                VStack (spacing: 5) {
                    Text("New around here?")
                    Button("Create An Account") {
                        viewModel.isRegisterPresented = true
                    }
                    .bold()
                    .foregroundColor(theme.mTintColor.opacity(0.9))
                }
                .padding(.bottom, 100)
                
            }
            .sheet(isPresented: $viewModel.isRegisterPresented) {
                RegisterView()
                    .presentationDetents([.large])
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.errorMessage))
            }
        }
    }


    @ViewBuilder
    private func HeaderView() -> some View {
        VStack (alignment: .leading, spacing: 30) {
            HStack (spacing: 5) {
                Text("Task")
                    .font(.system(size: 52)).bold()
                    .foregroundColor(.gray)

                Text("/")
                    .font(.system(size: 32)).bold()
                    .foregroundColor(.black)

                Text("Cycle")
                    .font(.system(size: 52)).bold()
                    .foregroundColor(theme.mTintColor)
            }
        }
        .hSpacing(.leading).padding(.leading, 30)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel())
            .environmentObject(Theme())
    }
}

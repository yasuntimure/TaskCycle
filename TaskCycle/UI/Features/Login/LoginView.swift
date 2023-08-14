//
//  LoginView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

struct LoginView: View {

    private enum Fields {
        case email, password
    }

    @StateObject var viewModel = LoginViewModel()

    @FocusState private var focusedField: Fields?

    var body: some View {

        ZStack {
            
            GradientView()
            
            VStack {
                HeaderView()


                // Sign In with Google
                SignInWithButton(signInType: .google) {
                    // TODO: Sign In action
                }



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
                .padding(.bottom, ScreenSize.width/10)
                
                VStack (spacing: 5) {
                    Text("New around here?")
                    Button("Create An Account") {
                        viewModel.isRegisterPresented = true
                    }
                    .bold()
                    .foregroundColor(Color.mTintColor.opacity(0.9))
                }
                .padding(.bottom, 100)
                
            }
            .sheet(isPresented: $viewModel.isRegisterPresented) {
                RegisterView()
                    .presentationDetents([.large])
            }
            .userId(viewModel.userId)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

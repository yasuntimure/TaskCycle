//
//  SignInWithButton.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-14.
//

import SwiftUI

fileprivate struct SignInModel {
    let title: String
    let imageName: String
}

enum SignInType {
    case google, apple

    fileprivate var model: SignInModel {
        switch self {
        case .google:
            return SignInModel(title: "Sign In with Google", imageName: "googleLogo")
        case .apple:
            return SignInModel(title: "Sign In with Apple", imageName: "appleLogo")
        }
    }
}

struct SignInWithButton: View {

    @State var width: CGFloat = ScreenSize.defaultWidth
    @State var height: CGFloat = 50
    @State var signInType: SignInType
    @State var action: () -> Void

    var cornerRadius: CGFloat = 20

    var body: some View {
        Button(action: action) {
            HStack {
                Text(signInType.model.title)
                    .font(.system(size: 20))
                    .foregroundColor(.secondary)
                    .hSpacing(.leading)
                    .padding(.leading)
                Image(signInType.model.imageName)
                    .resizable()
                    .frame(width: 25, height: 25)
                    .padding(.leading, 5)
                    .padding(.trailing)
            }
            .padding()
            .frame(width: ScreenSize.defaultWidth)
            .background()
            .cornerRadius(20)
        }
    }
}

struct SignInWithButton_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.backgroundColor
                .ignoresSafeArea()

            SignInWithButton(signInType: .google) {
                // Action
            }
        }
    }
}

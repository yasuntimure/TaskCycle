//
//  TextFieldView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-15.
//

import SwiftUI

class InputField: ObservableObject, Equatable {

    @Published var placeholder: String = ""
    @Published var text: String = ""
    @Published var validation: Validation = .none

    init(placeholder: String = "", text: String = "", validation: Validation = .none) {
        self.placeholder = placeholder
        self.text = text
        self.validation = validation
    }

    static func == (lhs: InputField, rhs: InputField) -> Bool {
        lhs.placeholder == rhs.placeholder
    }
}

struct TextFieldView: View {

    @EnvironmentObject var theme: Theme

    @Binding var input: InputField

    var isSecure: Bool = false

    var cornerRadius: CGFloat = 20

    var body: some View {
        
        VStack (alignment: .leading, spacing: 5) {
            Text(input.validation.message())
                .font(.caption2)
                .foregroundColor(input.validation.status() == .approved ? .green : .red)
                .bold()

                if isSecure {
                    SecureField(input.placeholder, text: $input.text)
                        .padding()
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(theme.mTintColor, lineWidth: 2)
                        )
                } else {
                    TextField(input.placeholder, text: $input.text)
                        .padding()
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(theme.mTintColor, lineWidth: 2)
                        )
                }

        }
        .hSpacing(.center)
        .padding(.horizontal)
        .frame(maxWidth: Constants.buttonMaxWidth)
    }

}

struct TextFieldView_Previews: PreviewProvider {


    static var email: InputField = InputField(placeholder: "Enter Email",
                                              text: "yasuntimure@gmail.com",
                                              validation: .email(.approved))

    static var previews: some View {
        Stateful(value: email) { email in
            TextFieldView(input: email, isSecure: false)
                .environmentObject(Theme())
                .previewLayout(.fixed(width: ScreenSize.width, height: ScreenSize.height/8))
        }
    }
}

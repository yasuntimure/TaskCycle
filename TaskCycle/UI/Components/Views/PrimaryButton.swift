//
//  ButtonView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-12.
//

import SwiftUI

struct PrimaryButton: View {

    @State var title: String
    @State var width: CGFloat = ScreenSize.defaultWidth
    @State var height: CGFloat = 50
    @State var action: () -> Void

    var cornerRadius: CGFloat = 20
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(width: width, height: height)
                .foregroundColor(.white)
                .font(.system(size: 20)).bold()
                .background(Color.mTintColor)
        }
        .cornerRadius(cornerRadius)
    }

}

struct PrimaryButton_Previews: PreviewProvider {
    static var previews: some View {
        PrimaryButton(title: "Login") {
            // action
        }
    }
}

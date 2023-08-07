//
//  HeaderView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-11.
//

import SwiftUI

struct HeaderView: View {

    @Environment (\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
            LogoView()
                .frame(width: ScreenSize.width/3, height: ScreenSize.width/3)
                .cornerRadius(ScreenSize.width)
                .foregroundColor(colorScheme == .light ? .black : .white)
                .aspectRatio(contentMode: .fill)
                .padding(.top, ScreenSize.width/3.5)
                .shadow(
                    color: colorScheme == .light ? .black : .white,
                    radius: 1
                )
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}

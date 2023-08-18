//
//  SettingsView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-12.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {

    @EnvironmentObject var viewModel: MainViewModel

    var body: some View {

        ZStack {
            Color.secondary
                .ignoresSafeArea()
                .opacity(0.2)

            VStack (alignment: .leading, spacing: 20) {

                Text(viewModel.userName)
                    .styleSettingRow()

                HStack {
                    Text("Email:")
                        .bold()
                    Text(viewModel.userEmail)
                }
                .styleSettingRow()

                SecondaryButton(title: "Logout") {
                    viewModel.logout()
                }
                .padding(.top)

                Spacer()
            }
            .padding([.top, .horizontal], 30)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.errorMessage))
            }
            .navigationTitle("Settings")
        }
    }

}



struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}

extension View {
    func styleSettingRow() -> some View {
        self.modifier(SettingsRowStyleModifier())
    }
}

struct SettingsRowStyleModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .font(.system(size: 18)).bold()
            .padding(.horizontal)
            .frame(width: ScreenSize.defaultWidth,
                   height: ScreenSize.defaultHeight,
                   alignment: .leading)
            .background(.secondary.opacity(0.3))
            .cornerRadius(ScreenSize.defaultHeight/3)

    }
}



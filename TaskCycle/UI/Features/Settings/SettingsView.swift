//
//  SettingsView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-12.
//

import SwiftUI
import PhotosUI

struct SettingsView: View {
    @EnvironmentObject var theme: Theme
    @EnvironmentObject var viewModel: MainViewModel
    @State var themeColors: [Color] = [.blue, .mint, .indigo, .cyan, .orange, .purple, .yellow, .green, .pink, .black, .brown, .gray, .red]

    var body: some View {
        VStack {
            HeaderView()

            LazyVStack (alignment: .leading, spacing: 20) {
                Text("Customize")
                    .foregroundColor(.secondary).bold()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 20) {
                        ForEach(themeColors, id: \.self) { color in
                            CircleButton(color)
                        }
                    }
                    .padding(5)
                }
                .styleSettingRow()

                Text("Support Us")
                    .foregroundColor(.secondary).bold()

                Row(title: "Buy me a coffee", image: "cup.and.saucer") { }
                Row(title: "Give us feedback", image: "star") { }

                Row(title: "Logout", image: "xmark.circle") {
                    viewModel.logout()
                }
                .font(.title3)
                .bold()
                .padding(.top)
            }
            .padding(.horizontal)
            .vSpacing(.top)
            .padding(.top)
            .alert(isPresented: $viewModel.showAlert) {
                Alert(title: Text(viewModel.errorMessage))
            }
            .tint(theme.mTintColor)
        }
    }

    @ViewBuilder
    private func Row(title: String, image: String?, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if let image = image {
                    Image(systemName: image)
                        .font(.title2)
                }
                Text(title)
                    .foregroundColor(.primary)
            }
            .styleSettingRow()
        }
    }

    @ViewBuilder
    private func CircleButton(_ color: Color) -> some View {
        Button(action: {
            withAnimation {
                theme.mTintColor = color
            }
        }) {
            VStack {
                Circle()
                    .fill(color)
                    .frame(width: theme.mTintColor == color ? 40 : 30,
                           height: theme.mTintColor == color ? 40 : 30)
                    .layeredBackground(color)

                if theme.mTintColor == color {
                    Circle()
                        .fill(color)
                        .frame(width: 8, height: 8)
                        .layeredBackground(color)
                }
            }
        }
    }

}

// MARK: - HeaderView

extension SettingsView {

    @ViewBuilder
    private func HeaderView() -> some View {
        VStack {
            HStack {
                // Title
                Text("Settings")
                    .font(.title.bold())
                    .hSpacing(.leading)
                    .foregroundColor(theme.mTintColor)
            }
            .padding([.top, .horizontal])

            Rectangle()
                .frame(width: ScreenSize.width, height: 2)
                .foregroundColor(.backgroundColor)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(MainViewModel())
            .environmentObject(Theme())
    }
}

fileprivate extension View {
    func styleSettingRow() -> some View {
        self.modifier(SettingsRowStyleModifier())
    }
}

fileprivate struct SettingsRowStyleModifier: ViewModifier {

    func body(content: Content) -> some View {
        content
            .padding(.vertical, 12)
            .hSpacing(.leading)
            .padding(.leading)
            .layeredBackground(Color.backgroundColor)
            .cornerRadius(12)

    }
}



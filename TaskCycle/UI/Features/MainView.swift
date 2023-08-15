//
//  MainView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-14.
//

import SwiftUI

struct MainView: View {

    @StateObject var loginViewModel = LoginViewModel()

    var body: some View {
        NavigationView {
            if !loginViewModel.userId.isEmpty {
                TabView {
                    DailyView(viewModel: DailyViewModel(userId: loginViewModel.userId))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tabItem {
                            Label("Daily", systemImage: "calendar")
                                .foregroundColor(.primary)
                        }
                    EmptyView()
                        .tabItem {
                            Label("Notes", systemImage: "note.text")
                                .foregroundColor(.primary)
                        }
                }

            } else {
                LoginView(viewModel: loginViewModel)
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

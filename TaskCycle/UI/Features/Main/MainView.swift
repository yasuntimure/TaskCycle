//
//  MainView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-14.
//

import SwiftUI

struct MainView: View {

    @StateObject var viewModel = MainViewModel()
    @StateObject var dailyViewModel = DailyViewModel()
    @StateObject var notesViewModel = NotesViewModel()

    @StateObject var theme: Theme = Theme()

    var body: some View {
        NavigationView {
            if viewModel.userId.isEmpty {
                LoginView(viewModel: LoginViewModel())
            } else {
                TabView {
                    DailyView(viewModel: dailyViewModel)
                        .tabItem {
                            Label("Daily", systemImage: "calendar")
                                .foregroundColor(theme.mTintColor)

                        }
                    NotesView(viewModel: notesViewModel)
                        .tabItem {
                            Label("Notes", systemImage: "list.clipboard")
                                .foregroundColor(theme.mTintColor)
                        }
                    SettingsView()
                        .tabItem {
                            Label("Settings", systemImage: "gearshape")
                                .foregroundColor(theme.mTintColor)
                        }
                }
                .tint(theme.mTintColor)
            }
        }
        .environmentObject(viewModel)
        .environmentObject(theme)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .environmentObject(Theme())
    }
}

@MainActor
class Theme: ObservableObject {
    @Published var mTintColor: Color = Color.blue
}

//
//  MainView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-14.
//

import SwiftUI

struct MainView: View {

    @StateObject var viewModel = MainViewModel()

    var body: some View {
        NavigationView {
            if viewModel.userId.isEmpty {
                LoginView(viewModel: LoginViewModel())
            } else {
                TabView {
                    DailyView(viewModel: DailyViewModel(userId: viewModel.userId))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .tabItem {
                            Label("Daily", systemImage: "calendar")
                                .foregroundColor(.mTintColor)
                                .tint(.mTintColor)
                        }
                    NotesView(viewModel: NotesViewModel(userId: viewModel.userId))
                        .tabItem {
                            Label("Notes", systemImage: "note.text")
                                .tint(.mTintColor)
                                .foregroundColor(.mTintColor)
                        }
                }
            }
        }
        .environmentObject(viewModel)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

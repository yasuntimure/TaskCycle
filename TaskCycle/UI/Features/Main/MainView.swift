//
//  ContentView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

struct MainView: View {

    @StateObject var viewModel = MainViewModel()

    var body: some View {
        NavigationView {
            if !viewModel.userId.isEmpty {
                AccountView
            } else {
                LoginView()
            }
        }
        .environmentObject(viewModel)
        .onUserIdChange { userId in
            self.viewModel.userId = userId
        }


    }
}

// MARK: - Account TabView

extension MainView {

    var AccountView: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Daily", systemImage: "calendar")
                        .foregroundColor(.primary)
                }
            ContentView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                        .foregroundColor(.primary)
                }
        }
    }

}


// MARK: - Preview

struct MainViewView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

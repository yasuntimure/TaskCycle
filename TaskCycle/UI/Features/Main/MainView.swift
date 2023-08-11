//
//  ContentView.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI

struct MainView: View {

    @StateObject var viewModel = MainViewModel()

    let list = ToDoListModel(id: "111", title: "My Lust", description: "LustLust",
                             items: [ToDoListItemModel(id: "120", title: "My Item", description: "My description", date: Date().timeIntervalSince1970), ToDoListItemModel(id: "121", title: "My Item", description: "", date: Date().timeIntervalSince1970), ToDoListItemModel(id: "122", title: "My Item", description: "", date: Date().timeIntervalSince1970),
                                     ToDoListItemModel(id: "123", title: "My Item", description: "My description", date: Date().timeIntervalSince1970),
                                     ToDoListItemModel(id: "124", title: "My Item", description: "My description My description My description My description My description My description My description My description My description My description My description", date: Date().timeIntervalSince1970)],
                             date: Date().timeIntervalSince1970)

    var body: some View {
        NavigationView {
            if !viewModel.userId.isEmpty {
                AccountView()
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

    func AccountView() -> some View {
        TabView {
            DailyView(viewModel: DailyViewModel(userId: viewModel.userId, list: list))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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

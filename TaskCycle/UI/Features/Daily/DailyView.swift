//
//  DailyView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-06.
//

import SwiftUI

struct DailyView<VM>: View where VM: DailyViewModelProtocol {
    
    @StateObject var viewModel: VM

    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 0) {
                VStack (alignment: .leading, spacing: 6) {
                    CustomDateView()
                        .hSpacing(.topLeading)
                        .overlay(alignment: .topTrailing) { ProfileImage() }
                        .padding(15)
                    
                    /// Week Slider
                    WeekSliderView(viewModel: viewModel.weekSliderViewModel)
                        .padding(.horizontal, -15)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 100)
                        .padding(.horizontal, 15)
                    
                    ToDoListView(viewModel: viewModel.toDoListViewModel)
                    
                }
                .hSpacing(.leading)
                .background(.white)
                .vSpacing(.top)
            }
            .background(Color.backgroundColor)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) { EditButton() }
            ToolbarItem(placement: .navigationBarTrailing) { settingsViewNavigation }
        }
        .sheet(isPresented: $viewModel.settingsViewPresented) {
            SettingsView()
                .presentationDetents([.fraction(0.45)])
        }
    }
}

// MARK: - Settings View Navigation

extension DailyView {

    var settingsViewNavigation: some View {
        Image(systemName: "gear")
            .resizable()
            .foregroundColor(.primary)
            .frame(width: 25, height: 25)
            .onTapGesture {
                viewModel.settingsViewPresented = true
            }

    }
}


struct DailyView_Previews: PreviewProvider {

    static let list = ToDoListModel(id: "111", title: "My Lust", description: "LustLust",
                                     items: [ToDoListItemModel(id: "120", title: "My Item", description: "", date: Date().timeIntervalSince1970), ToDoListItemModel(id: "121", title: "My Item", description: "", date: Date().timeIntervalSince1970), ToDoListItemModel(id: "122", title: "My Item", description: "", date: Date().timeIntervalSince1970),
                                             ToDoListItemModel(id: "123", title: "My Item", description: "", date: Date().timeIntervalSince1970),
                                             ToDoListItemModel(id: "124", title: "My Item", description: "", date: Date().timeIntervalSince1970)],
                                     date: Date().timeIntervalSince1970)


    static var previews: some View {
        DailyView(viewModel: DailyViewModel(userId: ""))
    }
}

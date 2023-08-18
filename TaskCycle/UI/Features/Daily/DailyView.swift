//
//  DailyView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-06.
//

import SwiftUI

struct DailyView: View {
    
    @ObservedObject var viewModel: DailyViewModel

    var body: some View {
        NavigationView {
            VStack (alignment: .leading, spacing: 0) {
                VStack (alignment: .leading, spacing: 6) {
                    CustomDateView()
                        .hSpacing(.topLeading)
                        .overlay(alignment: .topTrailing) { ProfileImage() }
                        .padding(.horizontal, 15)
                    
                    /// Week Slider
                    WeekSliderView()
                        .padding(.horizontal, -15)
                        .tabViewStyle(.page(indexDisplayMode: .never))
                        .frame(height: 100)
                        .padding(.horizontal, 15)
                    
                    ToDoListView()
                    
                }
                .hSpacing(.leading)
                .background(.white)
                .vSpacing(.top)
            }
            .background(Color.backgroundColor)
        }
        .environmentObject(viewModel)
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
    static var previews: some View {
        DailyView(viewModel: DailyViewModel(userId: ""))
            .environmentObject(MainViewModel())
    }
}

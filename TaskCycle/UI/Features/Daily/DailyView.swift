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
            ZStack {
                VStack (alignment: .leading, spacing: 6) {
                    HeaderView()
                        .onTapGesture {
                            hideKeyboard()
                        }

                    SliderView()

                    List {
                        ListRow()
                    }
                    .listStyle(.plain)
                    .refreshable {
                        viewModel.fetchItems()
                    }
                }
                .hSpacing(.leading)
                .background(.white)
                .vSpacing(.top)

                PlusButton() {
                    viewModel.addNewItem()
                    viewModel.fetchItems()
                }
                .vSpacing(.bottom).hSpacing(.trailing)
                .padding([.trailing,.bottom], 20)
                .padding(3)
            }
            .toolbarKeyboardDismiss()
        }
        .environmentObject(viewModel)
    }

    @ViewBuilder
    private func HeaderView() -> some View {
        CustomDateView()
            .hSpacing(.topLeading)
            .overlay(alignment: .topTrailing) { ProfileImage() }
            .padding(.horizontal)
            .padding(.top)
    }

    @ViewBuilder
    private func SliderView() -> some View {
        WeekSliderView()
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 100)
            .padding(.horizontal, 15)
    }

    @ViewBuilder
    private func ListRow() -> some View {
        ForEach ($viewModel.items) { $item in
            ToDoRow(item: $item)
                .padding(.vertical, -5)
                .hSpacing(.leading)
                .onChange(of: item) { newItem in
                    withAnimation {
                        viewModel.update(item: newItem)
                    }
                }
        }
        .onDelete(perform: viewModel.deleteItems(at:))
        .onMove(perform: viewModel.moveItems(from:to:))
        .listSectionSeparator(.hidden)
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

struct DailyView_Previews: PreviewProvider {
    static var previews: some View {
        DailyView(viewModel: DailyViewModel(userId: Mock.userId))
            .environmentObject(MainViewModel())
            .environmentObject(Theme())
    }
}


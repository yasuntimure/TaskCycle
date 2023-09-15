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
                    withAnimation {
                        viewModel.insertAndSaveEmptyItem()
                    }
                }
                .disabled(viewModel.items.contains(where: { $0.title.isEmpty }))
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
        ForEach ($viewModel.items) { $rowItem in
            ToDoRow(item: $rowItem)
                .padding(.vertical, -5)
                .hSpacing(.leading)
                .onChange(of: rowItem) { item in
                    withAnimation {
                        viewModel.update(item)
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
        DailyView(viewModel: DailyViewModel())
            .environmentObject(MainViewModel())
            .environmentObject(Theme())
    }
}


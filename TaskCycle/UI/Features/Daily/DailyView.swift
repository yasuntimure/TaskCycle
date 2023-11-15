//
//  DailyView.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-08-06.
//

import SwiftUI

struct DailyView: View {

    @EnvironmentObject var themeColor: Theme
    @ObservedObject var viewModel: DailyViewModel

    @State var showAlert = false

    var body: some View {
        ZStack {
            VStack (alignment: .leading, spacing: 6) {
                HeaderView()
                SliderView()
                if !viewModel.items.isEmpty {
                    EditButton()
                        .hSpacing(.trailing).padding(.trailing, 20)
                }
                List {
                    ListRow()
                }
                .listStyle(.plain)
                .overlay {
                    if viewModel.items.isEmpty {
                        ContentUnavailableView {
                            Label("Add a New Task", systemImage: "tray.fill")
                        } description: {
                            Text("There is no task set for the day!")
                        }
                        .padding(.bottom, 50)
                        .opacity(0.8)
                    }
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
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: {
                    hideKeyboard()
                }, label: { 
                    Image(systemName: "keyboard.chevron.compact.down.fill")
                        .font(.headline)
                        .tint(.secondary)
                })

                Spacer()

                Button(action: {
                    hideKeyboard()
                }, label: {
                    Text("Done")
                        .font(.headline).bold()
                        .tint(.primary)
                })
            }
        }
        .onAppear {
            viewModel.fetchItems()
        }
        .environmentObject(viewModel)
        .alert("Comming Soon!", isPresented: $showAlert) {}
    }

    @ViewBuilder
    private func HeaderView() -> some View {
        CustomDateView()
            .hSpacing(.topLeading)
            .overlay(alignment: .topTrailing) {
                Image(systemName: "calendar")
                    .font(.largeTitle)
                    .foregroundStyle(.secondary)
                    .onTapGesture {
                        showAlert = true
                    }
            }
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


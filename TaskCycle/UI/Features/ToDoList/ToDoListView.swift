////
////  ToDoListView.swift
////  ToDoList
////
////  Created by Eyüp on 2023-07-10.
////
//
//import SwiftUI
//
//struct ToDoListView: View {
//
//    @ObservedObject var viewModel: ToDoListViewModel
//
//    init(viewModel: ToDoListViewModel) {
//        self.viewModel = viewModel
//    }
//
//    var body: some View {
//            ZStack {
//
//                if viewModel.isLoading {
//                    LoadingView()
//                        .frame(width: 50, height: 50, alignment: .center)
//                }
//
//                List {
//                    ForEach ($viewModel.items) { $todoItem in
//                        ToDoListItemRow(item: $todoItem.onNewValue {
//                            withAnimation {
//                                viewModel.updateIsDoneStatus(of: todoItem)
//                            }
//                        })
//                    }
//                    .onDelete(perform: viewModel.deleteItems(at:))
//                    .onMove(perform: viewModel.moveItems(from:to:))
//                }
//                .onAppear {
//                    viewModel.fetchItems()
//                }
//                .refreshable {
//                    viewModel.fetchItems()
//                }
//                .toolbar {
//                    ToolbarItem(placement: .navigationBarTrailing) { EditButton() }
//                }
//
//                .listStyle(.plain)
//                .navigationTitle($viewModel.list.title)
//
//                .sheet(isPresented: $viewModel.newItemViewPresented) {
//                    NewNoteView()
//                        .presentationDetents([.fraction(0.55)])
//                        .environmentObject(viewModel)
//                }
//
//                plusButton
//        }
//    }
//
//}
//
//// MARK: - Plus Button
//
//extension ToDoListView {
//
//    var plusButton: some View {
//        VStack (alignment: .trailing) {
//            Spacer()
//            HStack {
//                Spacer()
//                PlusButton(size: 25) {
//                    viewModel.newItemViewPresented = true
//                }
//                .padding([.trailing, .bottom], 30)
//            }
//            .padding(.bottom)
//        }
//    }
//}
//
//struct ToDoListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ToDoListView(viewModel: ToDoListViewModel(userId: "", list: ToDoListModel(id: "", title: "", description: "", items: [], date: Date().timeIntervalSince1970)))
//    }
//}

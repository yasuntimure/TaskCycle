////
////  ToDoListViewModel.swift
////  ToDoList
////
////  Created by Eyüp on 2023-07-29.
////
//
//import SwiftUI
//import FirebaseAuth
//import FirebaseFirestore
//
//class ToDoListViewModel: ObservableObject {
//
//    @Published var newItemViewPresented = false
//
//    @Published var items: [ToDoItemModel] = []
//
//    @Published var newItem: ToDoListItem = ToDoListItem()
//
//    @Published var showAlert: Bool = false
//    @Published var errorMessage: String = ""
//
//    @Published var isLoading: Bool = false
//
//    var canSave: Bool {
//        !newItem.title.trimmingCharacters(in: .whitespaces).isEmpty
//    }
//
//    @Published var userId: String
//    @Published var list: ToDoListModel
//
//
//    init(userId: String, list: ToDoListModel) {
//        self.userId = userId
//        self.list = list
//    }
//
//
//    func fetchItems() {
//
//        isLoading = true
//
//        items = []
//
//        Firestore.firestore()
//            .collection("users")
//            .document(userId)
//            .collection("notes")
//            .document(list.id)
//            .collection("todos")
//            .getDocuments { [weak self] (querySnapshot, err) in
//            if let err = err {
//
//                print("Error getting documents: \(err)")
//
//            } else {
//
//                guard let documents = querySnapshot?.documents else {
//                    print("Documents couldnt casted")
//                    return
//                }
//
//                for document in documents {
//                    let result = Result {
//                        try document.data(as: ToDoListItemModel.self)
//                    }
//                    switch result {
//                    case .success(let item):
//                        self?.items.append(item)
//                    case .failure(let error):
//                        print("Error decoding item: \(error)")
//                    }
//                }
//                self?.reorder()
//                self?.isLoading = false
//            }
//        }
//
//
//    }
//
//    func reorder() {
//        items.sort(by: { !$0.isDone && $1.isDone })
//    }
//
//    func deleteItems(at indexSet: IndexSet) {
//        indexSet.forEach { index in
//            Firestore.firestore()
//                .collection("users")
//                .document(userId)
//                .collection("notes")
//                .document(list.id)
//                .collection("todos")
//                .document(items[index].id)
//                .delete { err in
//                    if let err = err {
//                        print("Error removing document: \(err)")
//                    } else {
//                        print("Document successfully removed!")
//                    }
//                }
//        }
//        items.remove(atOffsets: indexSet)
//    }
//
//    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
//        items.move(fromOffsets: indexSet, toOffset: newIndex)
//    }
//
//    func updateIsDoneStatus(of item: ToDoItemModel) {
//
//        let newStatus = item.isDone
//
//        Firestore.firestore()
//            .collection("users")
//            .document(userId)
//            .collection("notes")
//            .document(list.id)
//            .collection("todos")
//            .document(item.id)
//            .updateData(["isDone": newStatus]) { err in
//                if let err = err {
//                    print("Error updating document: \(err)")
//                } else {
//                    print("Document successfully updated")
//                }
//            }
//
//        // update local array
//        if let index = self.items.firstIndex(where: {$0.id == item.id}) {
//            self.items[index].set(newStatus)
//        }
//
//        self.reorder()
//    }
//    
//
//    func save() {
//
//        let item = newItem.getStructModel()
//
//        // Save model
//        Firestore.firestore()
//            .collection ("users")
//            .document(userId)
//            .collection("notes")
//            .document(list.id)
//            .collection("todos")
//            .document (item.id)
//            .setData(item.asDictionary())
//
//        newItem.reset()
//
//        fetchItems()
//
//    }
//
//}

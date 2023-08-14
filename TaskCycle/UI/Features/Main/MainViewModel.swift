//
//  ToDoListViewModel.swift
//  ToDoList
//
//  Created by Eyüp on 2023-07-10.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

class MainViewModel: ObservableObject {

    @Published var userId: String = ""
    @Published var userName: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var joinDate: String = "22.07.2023"

    @Published var showAlert: Bool = false
    @Published var errorMessage: String = ""

    @Published var lists: [ToDoListModel] = []
    @Published var newList: ToDoList = ToDoList()

    @Published var isLoading: Bool = false

    @Published var newListViewPresented = false

    private var handler: AuthStateDidChangeListenerHandle?

    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            if let uid = user?.uid, !uid.isEmpty {
                self?.userId = uid
                self?.userName = user?.displayName ?? ""
            }
        }

    }

    var canSave: Bool {
        !newList.title.trimmingCharacters(in: .whitespaces).isEmpty
    }


    func fetchLists() {
        lists = []

        isLoading = true

        Firestore.firestore()
            .collection("users")
            .document(userId)
            .collection("daily")
            .getDocuments { (querySnapshot, err) in

            if let err = err {

                print("Error getting documents: \(err)")

            } else {

                guard let documents = querySnapshot?.documents else {
                    print("Documents couldnt casted")
                    return
                }

                for document in documents {
                    let result = Result {
                        try document.data(as: ToDoListModel.self)
                    }
                    switch result {
                    case .success(let item):
                        self.lists.append(item)
                    case .failure(let error):
                        print("Error decoding item: \(error)")
                    }
                }

                self.isLoading = false
            }
        }
    }

    func deleteItems(at indexSet: IndexSet) {
        indexSet.forEach { index in
            Firestore.firestore()
                .collection("users")
                .document(self.userId)
                .collection("daily")
                .document(lists[index].id)
                .delete { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
        lists.remove(atOffsets: indexSet)
    }

    func moveItems(from indexSet: IndexSet, to newIndex: Int) {
        lists.move(fromOffsets: indexSet, toOffset: newIndex)
    }


    func saveNewList() {

        let list = newList.getStructModel()

        // Save model
        Firestore.firestore()
            .collection("users")
            .document(self.userId)
            .collection("daily")
            .document (list.id)
            .setData(list.asDictionary())

        newList.reset()

        fetchLists()
    }

    func logout(completion: @escaping () -> Void) {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            showAlert = true
            errorMessage = signOutError.description
        }

        completion()
    }

}

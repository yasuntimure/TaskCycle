// FirestorePath.swift
// TaskCycle
//
// Created by Eyüp on 2023-09-14.

import FirebaseFirestore

struct FirestorePath {

    private var currentReference: Any

    private init(reference: Any) {
        self.currentReference = reference
    }

    static func users(_ id: String) -> FirestorePath? {
        if !id.isEmpty {
            let ref: DocumentReference = FirebaseService.shared.database.collection(CollectionName.users.rawValue).document(id)
            return FirestorePath(reference: ref)
        }
        return nil
    }

    func weekDays(_ date: String? = nil) -> FirestorePath {
        guard let ref = currentReference as? DocumentReference else { fatalError("Invalid chaining") }
        if let date = date {
            let newRef: DocumentReference = ref.collection(CollectionName.weekdays.rawValue).document(date)
            return FirestorePath(reference: newRef)
        } else {
            let newRef: CollectionReference = ref.collection(CollectionName.weekdays.rawValue)
            return FirestorePath(reference: newRef)
        }
    }

    func items(_ id: String? = nil) -> FirestorePath {
        guard let ref = currentReference as? DocumentReference else { fatalError("Invalid chaining") }
        if let id = id {
            let newRef: DocumentReference = ref.collection(CollectionName.items.rawValue).document(id)
            return FirestorePath(reference: newRef)
        } else {
            let newRef: CollectionReference = ref.collection(CollectionName.items.rawValue)
            return FirestorePath(reference: newRef)
        }
    }

    func notes(_ id: String? = nil) -> FirestorePath {
        guard let ref = currentReference as? DocumentReference else { fatalError("Invalid chaining") }
        if let id = id {
            let newRef: DocumentReference = ref.collection(CollectionName.notes.rawValue).document(id)
            return FirestorePath(reference: newRef)
        } else {
            let newRef: CollectionReference = ref.collection(CollectionName.notes.rawValue)
            return FirestorePath(reference: newRef)
        }
    }

    func documentReference() -> DocumentReference? {
        return currentReference as? DocumentReference
    }

    func collectionReference() -> CollectionReference? {
        return currentReference as? CollectionReference
    }

    enum CollectionName: String {
        case users
        case weekdays
        case items
        case notes
    }
}

let ref = FirestorePath.users("123")?.weekDays("123").items("123")

//Firestore.firestore()
//    .collection("users")
//    .document("123")
//    .collection("weekDays")
//    .document("123")
//    .collection("items")
//    .document("123")

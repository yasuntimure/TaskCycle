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

    func asDocument() -> DocumentReference? {
        return currentReference as? DocumentReference
    }

    func asCollection() -> CollectionReference? {
        return currentReference as? CollectionReference
    }

    enum Collection: String {
        case users
        case weekdays
        case items
        case notes
        case todotasks
        case inprogresstasks
        case donetasks
    }

    static func users(_ id: String) -> FirestorePath? {
        if !id.isEmpty {
            let ref: DocumentReference = FirebaseService.shared.database.collection(Collection.users.rawValue).document(id)
            return FirestorePath(reference: ref)
        }
        return nil
    }

    func weekDays(_ date: String? = nil) -> FirestorePath {
        path(Collection.weekdays.rawValue, of: date)
    }

    func items(_ id: String? = nil) -> FirestorePath {
        path(Collection.items.rawValue, of: id)
    }

    func notes(_ id: String? = nil) -> FirestorePath {
        path(Collection.notes.rawValue, of: id)
    }

    func toDoTasks(_ id: String? = nil) -> FirestorePath {
        path(Collection.todotasks.rawValue, of: id)
    }

    func inProgressTasks(_ id: String? = nil) -> FirestorePath {
        path(Collection.inprogresstasks.rawValue, of: id)
    }

    func doneTasks(_ id: String? = nil) -> FirestorePath {
        path(Collection.donetasks.rawValue, of: id)
    }

    func path(_ collection: String, of id: String? = nil) -> FirestorePath {
        guard let ref = currentReference as? DocumentReference else { fatalError("Invalid chaining") }
        if let id = id {
            let newRef: DocumentReference = ref.collection(collection).document(id)
            return FirestorePath(reference: newRef)
        } else {
            let newRef: CollectionReference = ref.collection(collection)
            return FirestorePath(reference: newRef)
        }
    }
}

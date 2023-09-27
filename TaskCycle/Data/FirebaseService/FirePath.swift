// FirestorePath.swift
// TaskCycle
//
// Created by Eyüp on 2023-09-14.

import FirebaseFirestore

public struct FirePath {

    private var currentReference: Any

    enum PathType {
        case document(DocumentReference)
        case collection(CollectionReference)
    }

    var type: PathType {
        if let docRef = currentReference as? DocumentReference {
            return .document(docRef)
        } else if let collRef = currentReference as? CollectionReference {
            return .collection(collRef)
        } else {
            fatalError("Invalid Firestore reference type")
        }
    }

    private init(reference: Any) {
        self.currentReference = reference
    }

    func asDocument() -> DocumentReference? {
        if case .document(let docRef) = type {
            return docRef
        }
        return nil
    }

    func asCollection() -> CollectionReference? {
        if case .collection(let collRef) = type {
            return collRef
        }
        return nil
    }

    enum Collection: String {
        case users, weekdays, items, notes, todotasks, inprogresstasks, donetasks
    }

    static func users(_ id: String) -> FirePath? {
        if !id.isEmpty {
            let ref: DocumentReference = FirebaseService.shared.database.collection(Collection.users.rawValue).document(id)
            return FirePath(reference: ref)
        }
        return nil
    }

    func weekDays(_ date: String? = nil) -> FirePath {
        return path(Collection.weekdays.rawValue, of: date)
    }

    func items(_ id: String? = nil) -> FirePath {
        return path(Collection.items.rawValue, of: id)
    }

    func notes(_ id: String? = nil) -> FirePath {
        return path(Collection.notes.rawValue, of: id)
    }

    func toDoTasks(_ id: String? = nil) -> FirePath {
        return path(Collection.todotasks.rawValue, of: id)
    }

    func inProgressTasks(_ id: String? = nil) -> FirePath {
        return path(Collection.inprogresstasks.rawValue, of: id)
    }

    func doneTasks(_ id: String? = nil) -> FirePath {
        return path(Collection.donetasks.rawValue, of: id)
    }

    private func path(_ collection: String, of id: String? = nil) -> FirePath {
        guard let ref = currentReference as? DocumentReference else { fatalError("Invalid chaining") }
        if let id = id {
            let newRef: DocumentReference = ref.collection(collection).document(id)
            return FirePath(reference: newRef)
        } else {
            let newRef: CollectionReference = ref.collection(collection)
            return FirePath(reference: newRef)
        }
    }
}

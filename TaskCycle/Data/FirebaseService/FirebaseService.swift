//
//  FirebaseService.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-12.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import Foundation
import SwiftUI

enum Collections: String {
    case users = "users"
    case notes = "notes"
    case weekdays = "weekdays"
    case items = "items"
}

struct FirebaseService {
    static let shared = FirebaseService()
    let database = Firestore.firestore()
}

// MARK: - GET

extension FirebaseService {

    func get<T: Decodable>(of type: T, with query: Query) async -> Result<T, Error> {
        do {
            let querySnapshot = try await query.getDocuments()
            if let document = querySnapshot.documents.first {
                let data = try document.data(as: T.self)
                return .success(data)
            } else {
                print("Warning: \(#function) document not found")
                return .failure(FirebaseError.documentNotFound)
            }
        } catch let error {
            print("Error: \(#function) couldn't access snapshot, \(error)")
            return .failure(error)
        }
    }

    func getArray<T: Decodable>(of type: T,with query: Query) async -> Result<[T], Error> {
        do {
            var response: [T] = []
            let querySnapshot = try await query.getDocuments()

            for document in querySnapshot.documents {
                do {
                    let data = try document.data(as: T.self)
                    response.append(data)
                } catch let error {
                    print("Error: \(#function) document(s) not decoded from data, \(error)")
                    return .failure(error)
                }
            }
            return .success(response)
        } catch let error {
            print("Error: couldn't access snapshot, \(error)")
            return .failure(error)
        }
    }
}


// MARK: - POST & PUT

extension FirebaseService {

    func post<T: FirebaseIdentifiable>(_ value: T, to collection: String) async -> Result<T, Error> {
        let ref = database.collection(collection).document()
        var valueToWrite: T = value
        valueToWrite.id = ref.documentID
        do {
            try ref.setData(from: valueToWrite)
            return .success(valueToWrite)
        } catch let error {
            print("Error: \(#function) in collection: \(collection), \(error)")
            return .failure(error)
        }
    }

    func put<T: FirebaseIdentifiable>(_ value: T, to collection: String) async -> Result<T, Error> {
        let ref = database.collection(collection).document(value.id)
        do {
            try ref.setData(from: value)
            return .success(value)
        } catch let error {
            print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
            return .failure(error)
        }
    }
}


// MARK: - DELETE

extension FirebaseService {

    func delete<T: FirebaseIdentifiable>(_ value: T, in collection: String) async -> Result<Void, Error> {
        let ref = database.collection(collection).document(value.id)
        do {
            try await ref.delete()
            return .success(())
        } catch let error {
            print("Error: \(#function) in \(collection) for id: \(value.id), \(error)")
            return .failure(error)
        }
    }

}

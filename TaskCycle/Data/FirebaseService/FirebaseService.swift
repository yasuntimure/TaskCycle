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

    func getArray<T: Decodable>(of type: T, from collection: CollectionReference) async -> Result<[T], Error> {
        do {
            var response: [T] = []
            let querySnapshot = try await collection.getDocuments()

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

    func post<T: FirebaseIdentifiable>(_ value: T, to document: DocumentReference) async -> Result<Void, Error> {
        var valueToWrite: T = value
        valueToWrite.id = document.documentID
        do {
            try document.setData(from: valueToWrite)
            return .success(())
        } catch let error {
            print("Error: \(#function) in collection: \(document.path), \(error)")
            return .failure(error)
        }
    }

    func put<T: FirebaseIdentifiable>(_ value: T, to document: DocumentReference) async -> Result<Void, Error> {
        do {
            try document.setData(from: value)
            return .success(())
        } catch let error {
            print("Error: \(#function) in \(document.path) for id: \(value.id), \(error)")
            return .failure(error)
        }
    }
}


// MARK: - DELETE

extension FirebaseService {

    func delete(_ query: DocumentReference) async -> Result<Void, Error> {
        do {
            try await query.delete()
            return .success(())
        } catch let error {
            print("Error: \(#function) in \(query.path) for id: \(query.documentID), \(error)")
            return .failure(error)
        }
    }
}

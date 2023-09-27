//
//  Networking.swift
//  TaskCycle
//
//  Created by Eyüp on 2023-09-26.
//

import Firebase
import FirebaseFirestore

public enum FirestoreServiceError: Error {
    case invalidPath
    case invalidType
    case collectionNotFound
    case documentNotFound
    case unknownError
    case parseError
    case invalidRequest
    case operationNotSupported
    case invalidQuery
    case operationNotAllowed
}

// MARK: - FirestoreMethod

public enum FirestoreMethod {
    case get
    case post
    case put
    case delete
}

public enum FirestorePath {
    case collection(CollectionReference?)
    case document(DocumentReference?)
}

// MARK: - Endpoint

public protocol FirestoreEndpoint {
    var userID: String { get }
    var path: FirestorePath { get }
    var method: FirestoreMethod { get }
    var task: FirestoreRequestPayload { get }
}

// MARK: - FirestoreRequestPayload

public enum FirestoreRequestPayload {
    case requestPlain
    case createDocument(any FirebaseIdentifiable)
    case updateDocument(any FirebaseIdentifiable)
}

public protocol FirestoreServiceProtocol {
    func request<T: FirebaseIdentifiable>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> [T] where T: FirebaseIdentifiable
}

public final class FirestoreService: FirestoreServiceProtocol {

    public func request<T>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> [T] where T: FirebaseIdentifiable {
        switch endpoint.method {
        case .get:
            return try await handleGet(type, endpoint: endpoint)
        case .post:
            try await handleSet(type, endpoint: endpoint)
            return []
        case .put:
            try await handleSet(type, endpoint: endpoint)
            return []
        case .delete:
            try await handleDelete(endpoint: endpoint)
            return []
        }
    }

    private func handleGet<T: FirebaseIdentifiable>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws -> [T] {
        switch endpoint.path {
        case .collection(let collectionReference):
            guard let ref = collectionReference else {
                throw FirestoreServiceError.invalidPath
            }
            let querySnapshot = try await ref.getDocuments()
            var response: [T] = []
            for document in querySnapshot.documents {
                if let data = try? document.data(as: T.self) {
                    response.append(data)
                } else {
                    throw FirestoreServiceError.parseError
                }
            }
            return response
        case .document(let documentReference):
            guard let ref = documentReference, let singleResponse = try? await ref.getDocument(as: T.self) else {
                throw FirestoreServiceError.invalidPath
            }
            return [singleResponse]
        }
    }

    private func handleSet<T: FirebaseIdentifiable>(_ type: T.Type, endpoint: FirestoreEndpoint) async throws {
        guard case let .updateDocument(value) = endpoint.task, var model = value as? T else {
            throw FirestoreServiceError.invalidType
        }

        switch endpoint.path {
        case .collection:
            throw FirestoreServiceError.operationNotAllowed
        case .document(let documentReference):
            guard let ref = documentReference else {
                throw FirestoreServiceError.documentNotFound
            }

            if endpoint.method == .post {
                model.id = ref.documentID
            }

            try ref.setData(from: model)
        }
    }

    private func handleDelete(endpoint: FirestoreEndpoint) async throws {
        switch endpoint.path {
        case .collection:
            throw FirestoreServiceError.operationNotAllowed
        case .document(let documentReference):
            guard let ref = documentReference else {
                throw FirestoreServiceError.invalidPath
            }
            try await ref.delete()
        }
    }
}






//
//  HydraError.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import AlertToast
import Foundation

enum HydraError: Error {
    case runtimeError(String, Error)
    case runtimeError(String)
    case networkError(APIError)

    var localizedDescription: String {
        switch self {
        case .runtimeError(let message):
            return message
        case .networkError(let error):
            return error.localizedDescription
        }
    }

    var description: String {
        switch self {
        case .runtimeError(let message):
            return message
        case .networkError(let error):
            return error.description
        }
    }
}

enum HydraDataFetch<T>: Equatable {
    case fetching
    case idle
    case success(T)
    case failure(HydraError)

    // Equatable fix: https://stackoverflow.com/a/67260611
    static func == (lhs: HydraDataFetch, rhs: HydraDataFetch) -> Bool {
        lhs.value == rhs.value
    }

    var value: String? {
        return String(describing: self).components(separatedBy: "(").first
    }

    var alertType: AlertToast.AlertType {
        switch self {
        case .fetching:
            return .loading
        case .idle:
            return .loading
        case .success:
            return .complete(.green)
        case .failure:
            return .error(.red)
        }
    }
    
    var description: String {
        switch self {
        case .fetching:
            return "Loading"
        case .idle:
            return "Idle"
        case .success(let data):
            if let data = data as? String {
                return data
            }
            return "Success"
        case .failure(let error):
            return error.localizedDescription
        }
    }
}

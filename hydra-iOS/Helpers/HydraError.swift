//
//  HydraError.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

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
}

enum HydraDataFetch<T>: Equatable {
    case fetching
    case success(T)
    case failure(HydraError)

    // Equatable fix: https://stackoverflow.com/a/67260611
    static func == (lhs: HydraDataFetch, rhs: HydraDataFetch) -> Bool {
        lhs.value == rhs.value
    }

    var value: String? {
        return String(describing: self).components(separatedBy: "(").first
    }
}

//
//  TapService.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 23/02/2025.
//

import Foundation

struct TapService {
    func getProducts(tapKey: String) async throws -> [TapProduct] {
        do {
            let headers: [String: String] = [
                "Authorization": "Bearer \(tapKey)"
            ]
            let resp = try await APIService.fetch(
                [TapProduct].self,
                url: URL(string: "\(GlobalConstants.TAP)/products"),
                headers: headers)
            return resp
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch tap products", error)
            }
        }
    }
}

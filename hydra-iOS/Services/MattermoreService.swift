//
//  MattermoreService.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 31/12/2024.
//

import Foundation

struct MattermoreService {
    func executeDoorAction(token: String, action: String) async throws {
        do {
            try await APIService.execute(
                url: URL(string: "\(GlobalConstants.MATTERMORE)/api/door/\(token)/\(action)"))
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch ugent events", error)
            }
        }
    }
}

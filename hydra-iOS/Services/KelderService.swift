//
//  KelderService.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 31/12/2024.
//

import Foundation

struct KelderService {
    func sendKelderMessage(message: String) async throws {
        do {
            var headers = [String: String]()
            if let username = ZeusConfig.sharedInstance.username {
                headers["X-Username"] = username
            }
            try await APIService.execute(url: URL(string: "\(GlobalConstants.KELDER)/messages/"), body: message, headers: headers)
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch ugent events", error)
            }
        }
    }
}

//
//  TabService.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 31/12/2024.
//

import Foundation

struct TabService {
    func getOpenRequest(for name: String, tabKey: String) async throws -> [TabTransaction] {
        do {
            let headers: [String: String] = [
                "Authorization": "Bearer \(tabKey)"
            ]
            let resp = try await APIService.fetch(
                [TabTransaction].self,
                url: URL(string: "\(GlobalConstants.TAB)/users/\(name)/requests?state=open"),
                headers: headers)
            return resp
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch ugent events", error)
            }
        }
    }

    func postTabAction(for requestId: Int, action: String, tabKey: String) async throws {
        do {
            let headers: [String: String] = [
                "Authorization": "Bearer \(tabKey)"
            ]
            _ = try await APIService.execute(
                url: URL(string: "\(GlobalConstants.TAB)/requests/\(requestId)/\(action)"),
                headers: headers)
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch ugent events", error)
            }
        }
    }

    func getTransactions(for name: String, tabKey: String) async throws -> [TabTransaction] {
        do {
            let headers: [String: String] = [
                "Authorization": "Bearer \(tabKey)"
            ]
            let resp = try await APIService.fetch(
                [TabTransaction].self,
                url: URL(string: "\(GlobalConstants.TAB)/users/\(name)/transactions"),
                headers: headers)
            return resp
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch ugent events", error)
            }
        }
    }
}

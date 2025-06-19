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

    func getTapUser(tapKey: String, tapUsername: String) async throws -> TapUser {
        do {
            let headers: [String: String] = [
                "Authorization": "Bearer \(tapKey)"
            ]
            let resp = try await APIService.fetch(
                TapUser.self,
                url: URL(string: "\(GlobalConstants.TAP)/users/\(tapUsername)"),
                headers: headers)
            return resp
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch tap user", error)
            }
        }
    }

    func addOrder(tapKey: String, tapUsername: String, cart: [TapProduct: Int]) async throws {
        do {
            let body: [String: [String: [[String: Int]]]] = [
                "order": [
                    "order_items_attributes": cart.map { product, quantity in
                        var data: [String: Int] = [:]
                        data[String(product.id)] = quantity
                        return data
                    }
                ]
            ]
            let jsonBody = try JSONEncoder().encode(body)
            let headers: [String: String] = [
                "Authorization": "Bearer \(tapKey)"
            ]
            try await APIService.execute(
                url: URL(
                    string: "\(GlobalConstants.TAP)/users/\(tapUsername)/orders?state=pending"),
                body: String(data: jsonBody, encoding: .utf8)!,
                headers: headers)
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to send tap order", error)
            }
        }
    }
}

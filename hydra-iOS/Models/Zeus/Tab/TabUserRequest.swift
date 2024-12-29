//
//  TabRequest.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 29/12/2024.
//

import Foundation

struct TabUserRequest {
    struct TabUser: Decodable {
        var id: Int
        var name: String
        var balance: Int
    }

    static func fetch() async throws -> TabUser {
        guard let username = ZeusConfig.sharedInstance.username else {
            throw HydraError.runtimeError("Please set your username")
        }
        guard let tabToken = ZeusConfig.sharedInstance.tabToken else {
            throw HydraError.runtimeError("Please set your Tab API key")
        }
        
        let url = URL(string: "\(GlobalConstants.TAB)/users/\(username)")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tabToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try CustomDecoder().decode(TabUser.self, from: data)
    }
}
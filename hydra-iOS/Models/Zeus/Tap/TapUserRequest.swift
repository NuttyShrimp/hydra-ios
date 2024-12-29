//
//  TabRequest.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 29/12/2024.
//

import Foundation

struct TapUserRequest {
    struct TapUser: Decodable {
        var id: Int
        var name: String
        var avatarFileName: String
        var orderCount: Int
        var favorite: Int
        
        enum CodingKeys: String, CodingKey {
            case id, name, avatarFileName
//            case avatarFileName = "avatar_file_name"
            case orderCount = "ordersCount"
            case favorite = "dagschotelId"
        }
    }

    static func fetch() async throws -> TapUser {
        guard let username = ZeusConfig.sharedInstance.username else {
            throw HydraError.runtimeError("Please set your username")
        }
        guard let tapToken = ZeusConfig.sharedInstance.tapToken else {
            throw HydraError.runtimeError("Please set your Tap API key")
        }
        
        let url = URL(string: "\(GlobalConstants.TAP)/users/\(username)")!
        var request = URLRequest(url: url)
        request.addValue("Bearer \(tapToken)", forHTTPHeaderField: "Authorization")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return try CustomDecoder().decode(TapUser.self, from: data)
    }
}

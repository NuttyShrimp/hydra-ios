//
//  UGentNewsResponse.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

struct UGentNewsResponse: Decodable {
    var entries: [UGentNewsEvent]
}

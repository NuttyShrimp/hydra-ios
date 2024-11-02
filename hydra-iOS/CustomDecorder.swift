//
//  CustomDecorder.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/10/2024.
//

import Foundation

class CustomDecoder: JSONDecoder, @unchecked Sendable {
    let dateFormatter = DateFormatter()

    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
        dateDecodingStrategy = .iso8601
    }
}


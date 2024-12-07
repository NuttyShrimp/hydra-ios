//
//  CustomDecorder.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/10/2024.
//

import Foundation

class CustomDecoder: JSONDecoder, @unchecked Sendable {
    override init() {
        super.init()
        keyDecodingStrategy = .convertFromSnakeCase
        dateDecodingStrategy = .iso8601
    }
}

class MealDecoder: JSONDecoder, @unchecked Sendable {
    override init() {
        super.init()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        dateDecodingStrategy = .formatted(formatter)
        keyDecodingStrategy = .convertFromSnakeCase
    }
}


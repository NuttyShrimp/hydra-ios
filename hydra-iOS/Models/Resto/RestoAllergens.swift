//
//  RestoAllergens.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 21/12/2024.
//

import Foundation

typealias RestoAllergensMap = [String: [String: [String]]]

struct RestoAllergensHolder {
    private var allergens: RestoAllergensMap = [:]
    
    @MainActor
    mutating func load() async throws {
        guard
            let url = URL(
                string: "\(Constants.ZEUS_V2)/resto/allergens.json")
        else { return }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        allergens = try CustomDecoder().decode(
            RestoAllergensMap.self, from: data)
    }
    
    func get(type: String, for food: String) -> [String]? {
        allergens[type]?[food]
    }
}

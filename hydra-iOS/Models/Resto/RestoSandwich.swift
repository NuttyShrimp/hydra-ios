//
//  RestoSandwich.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/12/2024.
//

import Foundation

struct RestoSandwich: Decodable, Identifiable {
    var name: String
    var price: String
    var ingredients: [String]
    
    var id: String { name }

    enum CodingKeys: String, CodingKey {
        case name, ingredients
        case price = "priceMedium"
    }
}

struct RestoSandwichHolder {
    var sandwiches: [RestoSandwich] = []

    mutating func load() async throws {
        guard
            let url = URL(
                string: "\(Constants.ZEUS_V2)/resto/sandwiches.json")
        else { return }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        sandwiches = try CustomDecoder().decode(
            [RestoSandwich].self, from: data)
    }
}


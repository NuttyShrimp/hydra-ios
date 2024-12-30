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

    func intoOtherMenuItem(allergens: [String]?) -> RestoOtherMenuItem {
        RestoOtherMenuItem(
            name: name, price: price,
            description: ingredients.joined(separator: ", "),
            allergens: allergens)
    }
}

//
//  RestoSalad.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 15/12/2024.
//

import Foundation

struct RestoSalad: Decodable {
    var name: String
    var description: String
    var price: String

    func intoOtherMenuItem(allergens: [String]?) -> RestoOtherMenuItem {
        RestoOtherMenuItem(
            name: name, price: price, description: description,
            allergens: allergens)
    }
}

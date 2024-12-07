//
//  RestoMeal.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 23/11/2024.
//

struct RestoMeal: Decodable {
    var name: String
    var price: String?
    var type: String?
    var kind: RestoMealKind
    var allergens: [String]
}

enum RestoMealKind: String, Decodable {
    case fish, meat, vegan, vegetarian, soup
}

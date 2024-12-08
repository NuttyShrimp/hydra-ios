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

enum RestoMealKind: String, Decodable, CaseIterable {
    case meat, fish, soup, vegetarian, vegan

    func toString() -> String {
        switch self {
        case .fish:
            return "Vis"
        case .meat:
            return "Vlees"
        case .vegan:
            return "Vegan"
        case .vegetarian:
            return "Vegetarisch"
        case .soup:
            return "Soep"
        }
    }
}

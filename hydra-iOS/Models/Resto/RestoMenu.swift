//
//  RestoMenu.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 23/11/2024.
//

import Foundation

struct RestoMenu: Decodable {
    var date: Date
    var meals: [RestoMeal]
    var open: Bool
    var vegetables: [RestoMeal]
    var message: String?

    enum CodingKeys: String, CodingKey {
        case date, meals, open, message
        case vegetables = "vegetables2"
    }

    mutating func fixSoups() {
        // Get the price for a big soup
        let allSoups = self.meals.filter { $0.kind == .soup }
        let bigPrice = allSoups.first(where: {
            $0.name.contains("groot") || $0.name.contains("big")
        })?.price

        // Remove all big soups from the meals list
        self.meals = self.meals.filter {
            $0.kind != .soup || (!$0.name.contains("groot")
                && !$0.name.contains("big"))
        }
        if let bigPrice = bigPrice {
            for index in meals.indices {
                if meals[index].kind == .soup {
                    // Remove small & klein suffix
                    meals[index].name = meals[index].name.replacingOccurrences(
                        of: "klein", with: ""
                    ).replacingOccurrences(of: "small", with: "")

                    meals[index].price =
                        meals[index].price != nil
                        ? meals[index].price! + " / " + bigPrice : bigPrice
                }
            }
        }

    }

    func hotMeals() -> [RestoMeal] {
        return self.meals.filter { $0.type != "cold" && $0.kind != .soup }
    }

    func coldMeals() -> [RestoMeal] {
        return self.meals.filter { $0.type == "cold" && $0.kind != .soup }
    }

    func soups() -> [RestoMeal] {
        return self.meals.filter { $0.kind == .soup }
    }

}

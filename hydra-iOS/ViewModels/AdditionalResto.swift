//
//  RestoAdditional.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 15/12/2024.
//

import Foundation
import OrderedCollections

class AdditionalResto: ObservableObject {
    @Published private var sandwichHolder = RestoSandwichHolder()
    @Published private var saladHolder = RestoSaladHolder()
    @Published private var additionalItems = RestoExtraFoodItemHolder()
    @Published private var allergens = RestoAllergensHolder()

    var availableSandwiches: [OtherMenuItem] {
        sandwichHolder.sandwiches.map {
            OtherMenuItem(
                name: $0.name, price: $0.price, description: $0.ingredients.joined(separator: ", "),
                allergens: allergens.get(type: "belegde broodjes", for: $0.name.lowercased()))
        }
    }

    var availableSalads: [OtherMenuItem] {
        saladHolder.salads.map {
            OtherMenuItem(
                name: $0.name, price: $0.price, description: $0.description,
                allergens: allergens.get(type: "saladbar", for: $0.name.lowercased()))
        }
    }

    var availableItems: OrderedDictionary<String, [OtherMenuItem]> {
        var ordDict = OrderedDictionary<String, [OtherMenuItem]>()
        ordDict["Broodjes"] = availableSandwiches
        ordDict["Salades"] = availableSalads

        // API doesn't provide proper allergens definition for the extra food items
        for item in additionalItems.items {
            ordDict[item.key, default: []].append(contentsOf: item.value)
        }

        return ordDict
    }

    @MainActor
    func loadAllInfo() async {
        do {
            try await sandwichHolder.load()
            try await saladHolder.load()
            try await additionalItems.load()
            try await allergens.load()
        } catch {
            print("Error loading additional resto info: \(error)")
        }
    }
}

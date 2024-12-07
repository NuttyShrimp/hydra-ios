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
    
    enum CodingKeys: String, CodingKey {
        case date, meals, open
        case vegetables = "vegetables2"
    }
}

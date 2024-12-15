//
//  RestoExtraFoodItem.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 15/12/2024.
//

import Foundation

struct RestoExtraFoodItemHolder {
    var items: [String : [OtherMenuItem]] = [:]
    
    mutating func load() async throws {
        guard
            let url = URL(
                string: "\(Constants.ZEUS_V2)/resto/extrafood.json")
        else { return }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        items = try CustomDecoder().decode(
            [String : [OtherMenuItem]].self, from: data)
    }
}

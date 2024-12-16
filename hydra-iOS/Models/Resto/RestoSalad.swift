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
}

struct RestoSaladHolder {
    var salads: [RestoSalad] = []

    @MainActor
    mutating func load() async throws {
        guard
            let url = URL(
                string: "\(Constants.ZEUS_V2)/resto/salads.json")
        else { return }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        salads = try CustomDecoder().decode(
            [RestoSalad].self, from: data)
    }
}

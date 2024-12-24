//
//  InfoHolder.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 24/12/2024.
//

import Foundation

struct InfoEntry: Decodable, Identifiable {
    var title: String
    var image: String?
    var url: String?
    var html: String?
    var subcontent: [InfoEntry]?
    
    var id: String { title }
}

struct InfoHolder {
    var entries: [InfoEntry] = []

    @MainActor
    mutating func load() async throws {
        guard
            let url = URL(
                string: "\(GlobalConstants.ZEUS_V2)/info/info-content.json")
        else { return }

        let (data, _) = try await URLSession.shared.data(from: url)
        
        entries = try CustomDecoder().decode(
            [InfoEntry].self, from: data)
    }
}

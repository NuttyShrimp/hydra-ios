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
    
    func loadWebPage() async throws -> String {
        guard let html = html else { return "" }
        guard
            let url = URL(
                string: "\(GlobalConstants.ZEUS_V2)/info/\(html)")
        else { return "" }

        let (data, _) = try await URLSession.shared.data(from: url)
        return String(data: data, encoding: .utf8) ?? ""
    }
}

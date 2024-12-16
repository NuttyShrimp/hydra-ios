//
//  UGentNewsHolder.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

public struct UGentNewsEventHolder {
    private(set) var events: [UGentNewsEvent] = []
    
    @MainActor
    mutating func loadEvents() async throws {
         debugPrint("Loading UGent news events")
         let url = URL(string: "\(Constants.ZEUS_V2)/news/nl.json")!
        
         let (data, _) = try await URLSession.shared.data(from: url)
         
        let response = try CustomDecoder().decode(UGentNewsResponse.self, from: data)
         events = response.entries
         
         debugPrint("Loaded \(events.count) UGent news events")
    }
}

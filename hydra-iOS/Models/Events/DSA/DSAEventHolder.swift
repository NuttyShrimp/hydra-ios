//
//  DsaEventHolder.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

public struct DSAEventHolder {
    private(set) var events: [DSAEvent] = []
    
    mutating func loadEvents() async throws {
         debugPrint("Loading DSA events")
         var url = URL(string: "\(Constants.DSA)/activiteiten")!
         url.append(queryItems: [URLQueryItem(name: "page_size", value: "50")])
         
         let (data, _) = try await URLSession.shared.data(from: url)
         
         let response = try CustomDecoder().decode(DSAEventResponse.self, from: data)
         events = response.page.entries
         
         for index in events.indices {
             events[index].updateId(
                 "DSA-\(events[index].entryId)")
         }

         debugPrint("Loaded \(events.count) DSA events")
    }
}

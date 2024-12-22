//
//  SpecialEventHolder.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

struct SpecialEventHolder {
    private(set) var events: [SpecialEvent] = []

    @MainActor
    mutating func loadEvents() async throws {
        debugPrint("Loading special events")
        let url = URL(
            string: "\(GlobalConstants.ZEUS_V2)/association/special_events.json")!

        let (data, _) = try await URLSession.shared.data(from: url)

        let response = try CustomDecoder().decode(
            SpecialEventResponse.self, from: data)
        
        events.removeAll();
        let now = Date.now
        for idx in response.specialEvents.indices {
            var event = response.specialEvents[idx]
            if (event.start.isBefore(now) && event.end.isAfter(now)) || Configuration.EventFeedShowAllSpecials {
                event.id = "Special-\(event.entryId)"
                events.append(event)
            }
        }
        
        debugPrint("Loaded \(events.count) Special events")
    }
}

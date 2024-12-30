//
//  UgentService].swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 30/12/2024.
//

import Foundation

struct ZeusService {
    struct Ugent: EventService {
        func fetchEvents() async throws -> [UGentNewsEvent] {
            do {
                let resp = try await APIService.fetch(UGentNewsResponse.self, url: URL(string:"\(GlobalConstants.ZEUS_V2)/news/nl.json"))
                return resp.entries
            } catch {
                if let error = error as? APIError {
                    throw HydraError.networkError(error)
                } else {
                    throw HydraError.runtimeError("Failed to fetch ugent events", error)
                }
            }

        }
    }
    
    struct SpecialEvents: EventService {
        func fetchEvents() async throws -> [SpecialEvent] {
            do {
                let response = try await APIService.fetch(SpecialEventResponse.self, url: URL(string:"\(GlobalConstants.ZEUS_V2)/association/special_events.json"))
                let now = Date.now
                var events: [SpecialEvent] = []
                for idx in response.specialEvents.indices {
                    var event = response.specialEvents[idx]
                    if (event.start.isBefore(now) && event.end.isAfter(now)) || Configuration.EventFeedShowAllSpecials {
                        event.id = "Special-\(event.entryId)"
                        events.append(event)
                    }
                }
                return events
            } catch {
                if let error = error as? APIError {
                    throw HydraError.networkError(error)
                } else {
                    throw HydraError.runtimeError("Failed to fetch ugent events", error)
                }
            }

        }
    }
}

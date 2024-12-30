//
//  DSAService.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 30/12/2024.
//

import Foundation

struct DSAService: EventService {
    func fetchAssocations() async throws -> [Association] {
        do {
            let resp = try await APIService.fetch(AssociationResponse.self, url: URL(string:"\(GlobalConstants.DSA)/verenigingen"))
            return resp.associations
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch associations", error)
            }
        }
    }
    
    func fetchEvents() async throws -> [DSAEvent] {
        do {
            var url = URL(string:"\(GlobalConstants.DSA)/activiteiten")
            url?.append(queryItems: [URLQueryItem(name: "page_size", value: "50")])
            
            let resp = try await APIService.fetch(DSAEventResponse.self, url: url)
            
            var events = resp.page.entries
            for index in events.indices {
                events[index].id = "DSA-\(events[index].entryId)"
            }
            
            return events
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch associations", error)
            }
        }

    }
}

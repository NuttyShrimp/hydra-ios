//
//  UgentService].swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 30/12/2024.
//

import Foundation

struct HydraService {
    struct Ugent: EventService {
        func fetchEvents() async throws -> [UGentNewsEvent] {
            do {
                let resp = try await APIService.fetch(
                    UGentNewsResponse.self,
                    url: URL(string: "\(GlobalConstants.ZEUS_V2)/news/nl.json"))
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
                let response = try await APIService.fetch(
                    SpecialEventResponse.self,
                    url: URL(string: "\(GlobalConstants.ZEUS_V2)/association/special_events.json"))
                let now = Date.now
                var events: [SpecialEvent] = []
                for idx in response.specialEvents.indices {
                    var event = response.specialEvents[idx]
                    if (event.start.isBefore(now) && event.end.isAfter(now))
                        || Configuration.EventFeedShowAllSpecials
                    {
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

    func loadRestaurantLocations() async throws -> [RestoLocation] {
        do {
            let response = try await APIService.fetch(
                RestoLocationResponse.self,
                url: URL(string: "\(GlobalConstants.ZEUS_V2)/resto/meta.json"))
            return response.locations.filter { $0.endpoint != nil }
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch restaurant locations", error)
            }
        }
    }

    func loadRestaurantMenus(for location: String) async throws -> [RestoMenu] {
        do {
            var response = try await APIService.fetch(
                [RestoMenu].self,
                url: URL(string: "\(GlobalConstants.ZEUS_V2)/resto/menu/\(location)/overview.json"),
                decoder: MealDecoder())
            response.indices.forEach { response[$0].fixSoups() }
            return response
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch restaurant menu's", error)
            }
        }
    }

    func loadSandwiches() async throws -> [RestoSandwich] {
        do {
            return try await APIService.fetch(
                [RestoSandwich].self,
                url: URL(string: "\(GlobalConstants.ZEUS_V2)/resto/sandwiches.json"))
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch sandwiche menu", error)
            }
        }
    }

    func loadSalads() async throws -> [RestoSalad] {
        do {
            return try await APIService.fetch(
                [RestoSalad].self, url: URL(string: "\(GlobalConstants.ZEUS_V2)/resto/salads.json"))
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch salad menu", error)
            }
        }
    }

    func loadExtraFood() async throws -> [String: [RestoOtherMenuItem]] {
        do {
            return try await APIService.fetch(
                [String: [RestoOtherMenuItem]].self,
                url: URL(string: "\(GlobalConstants.ZEUS_V2)/resto/extrafood.json"))
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch extra food items", error)
            }
        }
    }

    typealias Allergens = [String: [String: [String]]]
    func loadAllergens() async throws -> Allergens {
        do {
            return try await APIService.fetch(Allergens.self, url: URL(string: "\(GlobalConstants.ZEUS_V2)/resto/allergens.json"))
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch allergens info", error)
            }
        }
    }

    func loadInfo() async throws -> [InfoEntry] {
        do {
            return try await APIService.fetch([InfoEntry].self, url: URL(string: "\(GlobalConstants.ZEUS_V2)/info/info-content.json"))
        } catch {
            if let error = error as? APIError {
                throw HydraError.networkError(error)
            } else {
                throw HydraError.runtimeError("Failed to fetch extra info", error)
            }
        }
    }
}

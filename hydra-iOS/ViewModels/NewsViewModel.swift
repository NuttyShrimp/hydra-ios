//
//  NewsViewModel.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import Alamofire
import Foundation

private var DAY: TimeInterval = 24 * 60 * 60

class NewsViewModel: ObservableObject {
    // NOTE: Should this be moved to a model?
    @Published private(set) var DSAEvents: [DSAEvent] = []
    @Published private var UGentNews: [UgentNewsEntry] = []
    
    var events: [any Eventable] {
        // TODO: push events to the front if they happen in the future but in less than 24h
        return ((DSAEvents as [any Eventable]) + (UGentNews as [any Eventable]))
            .sorted {
                // if one of the dates is between now and now + 24h, push to front otherwise compare
                let isEvent0Soon = isEventSoon($0)
                let isEvent1Soon = isEventSoon($1)
                if isEvent0Soon && !isEvent1Soon {
                    return true
                }
                if !isEvent0Soon && isEvent1Soon {
                    return false
                }
                // true = $0 is before $1
                return $0.eventDate < $1.eventDate
            }

    }

    func loadEvents() {
        loadDSAEvents()
        LoadUgentNews()
    }

    private func loadDSAEvents() {
        debugPrint("Loading DSA events")
        AF.request("\(Constants.DSA)/activiteiten").responseDecodable(
            of: DSAResponse.self, decoder: CustomDecoder()
        ) { response in
            do {
                self.DSAEvents = try response.result.get().page.entries
                for index in self.DSAEvents.indices {
                    self.DSAEvents[index].updateId(
                        "DSA-\(self.DSAEvents[index].entryId)")
                }
                debugPrint("Loaded \(self.DSAEvents.count) DSA events")
            } catch {
                // TODO: Add notification that fetch failed
                print("Failed to fetch DSA events: \(error)")
            }
        }
    }

    private func LoadUgentNews() {
        debugPrint("Loading Ugent News")
        AF.request("\(Constants.ZEUS_V2)/news/nl.json").responseDecodable(
            of: UgentNewsResponse.self, decoder: CustomDecoder()
        ) { response in
            do {
                self.UGentNews = try response.result.get().entries
                debugPrint("Loaded \(self.UGentNews.count) Ugent news")
            } catch {
                // TODO: Add notification that fetch failed
                print("Failed to fetch Ugent news: \(error)")
            }
        }
    }
    
    private func isEventSoon(_ event: any Eventable) -> Bool {
        return Date.now.addingTimeInterval(DAY * -1) < event.eventDate && event.eventDate < Date.now.addingTimeInterval(DAY)
    }
}

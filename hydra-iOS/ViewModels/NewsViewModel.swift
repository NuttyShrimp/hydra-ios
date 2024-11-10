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
    // TODO: Make eventHolder protocol to use loops for functions
    @Published private var dsaEventHolder = DSAEventHolder();
    @Published private var ugentEventHolder = UGentNewsEventHolder();
    
    var events: [any Eventable] {
        // TODO: push events to the front if they happen in the future but in less than 24h
        return ((dsaEventHolder.events as [any Eventable]) + (ugentEventHolder.events as [any Eventable]))
            .sorted {
                $0.priority() < $1.priority()
            }
    }

    func loadEvents() {
        Task {
            do {
                try await dsaEventHolder.loadEvents()
            } catch {
                debugPrint("Failed to load DSA Events: \(error)")
            }
        }
        Task {
            do {
                try await ugentEventHolder.loadEvents()
            } catch {
                debugPrint("Failed to load Ugent news events: \(error)")
            }
        }
    }

    private func isEventSoon(_ event: any Eventable) -> Bool {
        return Date.now.addingTimeInterval(DAY * -1) < event.eventDate && event.eventDate < Date.now.addingTimeInterval(DAY)
    }
}

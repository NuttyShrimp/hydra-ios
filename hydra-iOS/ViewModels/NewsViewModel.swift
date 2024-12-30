//
//  NewsViewModel.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import Foundation

private let DAY: TimeInterval = 24 * 60 * 60

class NewsViewModel: ObservableObject {
    @Published var events: HydraDataFetch<[any Eventable]> = .fetching

    private let dsaService = DSAService()
    private let ugentService = ZeusService.Ugent()
    private let specialService = ZeusService.SpecialEvents()

    @MainActor
    func loadEvents() async {
        events = .fetching
        await loadEvents(service: dsaService)
        await loadEvents(service: ugentService)
        await loadEvents(service: specialService)
        if case .success(let data) = events {
            events = .success(data.sorted(by: { $0.priority() < $1.priority() }))
        }
    }

    @MainActor
    private func loadEvents(service: any EventService) async {
        // Note: this will show no events on the home screen when 1 of the API calls fails, it is a tradeoff I am willing to make
        if case .failure = events {
            return
        }
        do {
            let data = try await service.fetchEvents()
            if case .success(let currentData) = events {
                events = .success(currentData + data)
            } else {
                events = .success(data)
            }
        } catch {
            if let hydraError = error as? HydraError {
                events = .failure(hydraError)
            } else {
                events = .failure(
                    HydraError.runtimeError("Failed to load events", error))
            }
        }
    }

}

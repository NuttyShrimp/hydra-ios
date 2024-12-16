//
//  Restos.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

@MainActor
class RestoDocument: ObservableObject {
    @Published private(set) var restoMetas: [RestoMeta] = []
    @Published private var restoMenu: [RestoMenu] = []
    @Published private var selectedResto: Int = 0
    @Published var selectedDate: Int = 0
    
    var selectedRestoMeta: RestoMeta? {
        if restoMetas.count <= selectedResto {
            return nil
        }
        return restoMetas[selectedResto]
    }

    var selectedRestoMenu: RestoMenu? {
        if restoMenu.count <= selectedDate || selectedDate < 0 {
            return nil
        }
        return restoMenu[selectedDate]
    }

    var mealBarTabs: [String] {
        get { ["Legende"] + restoMenu.map { $0.date.relativeDayOfWeek() } }
        set {}
    }
    
    func loadAvailableRestos() async {
        debugPrint("Loading resto metadata")
        do {
            guard let url = URL(string: "\(Constants.ZEUS_V2)/resto/meta.json")
            else { return }

            let (data, _) = try await URLSession.shared.data(from: url)

            let response = try CustomDecoder().decode(
                RestoMetaResponse.self, from: data)
            restoMetas = response.locations.filter { $0.endpoint != nil }

            debugPrint("Loaded \(restoMetas.count) resto's metadata")

            if restoMetas.count > 0 {
                try await loadMeals()
            }
        } catch {
            debugPrint("Failed to load available restos \(error)")
        }
    }
    
    private func loadMeals() async throws {
        debugPrint("Loading resto menu")

        guard let selectedRestoMeta = selectedRestoMeta?.endpoint else {
            throw HydraError.runtimeError("No selected resto")
        }

        let url = URL(
            string:
                "\(Constants.ZEUS_V2)/resto/menu/\(selectedRestoMeta)/overview.json"
        )!

        let (data, _) = try await URLSession.shared.data(from: url)

        restoMenu = try MealDecoder().decode([RestoMenu].self, from: data)
        restoMenu.indices.forEach { restoMenu[$0].fixSoups() }

        debugPrint("Loaded \(restoMenu.count) days of resto menus")
    }

    func selectResto(_ index: Int) {
        selectedResto = index
        Task {
            do {
                try await loadMeals()
            } catch {
                debugPrint("Failed to load meals for resto \(error)")
            }
        }
    }
}

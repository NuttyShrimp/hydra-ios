//
//  Restos.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation
import OrderedCollections

class RestoDocument: ObservableObject {
    typealias RestoAllergensMap = [String: [String: [String]]]

    @Published var restoLocations: HydraDataFetch<[RestoLocation]> = .fetching
    @Published var selectedRestoMenus: HydraDataFetch<[RestoMenu]> = .fetching
    @Published var additionalMenuItems: HydraDataFetch<OrderedDictionary<String, [RestoOtherMenuItem]>> =
        .fetching
    @Published var allergens: HydraDataFetch<[String: [String: [String]]]> = .fetching
    @Published var selectedResto: Int = 0
    @Published var selectedDate: Int = 0

    private let userDefaults = UserDefaults.standard
    private let hydraService = HydraService()

    var selectedRestoLocation: RestoLocation? {
        guard case .success(let restoLocations) = restoLocations else {
            return nil
        }
        if restoLocations.count <= selectedResto {
            return nil
        }
        return restoLocations[selectedResto]
    }

    var selectedRestoMenu: RestoMenu? {
        guard case .success(let selectedRestoMenus) = selectedRestoMenus else {
            return nil
        }
        if selectedRestoMenus.count <= selectedDate || selectedDate < 0 {
            return nil
        }
        return selectedRestoMenus[selectedDate]
    }

    // Manual get/set is needed because we use "return" in the get scope
    var mealBarTabs: [String] {
        get {
            var tabs = ["Legende"]
            if case .success(let data) = selectedRestoMenus {
                tabs += data.map { $0.date.relativeDayOfWeek() }
            }
            return tabs
        }
        set {}
    }

    func getMenuForDay(day index: Int) -> RestoMenu? {
        guard case .success(let selectedRestoMenus) = selectedRestoMenus else {
            return nil
        }
        if selectedRestoMenus.count <= index || index < 0 {
            return nil
        }
        return selectedRestoMenus[index]
    }

    @MainActor
    func loadAvailableRestos() async {
        restoLocations = .fetching
        do {
            let locs = try await hydraService.loadRestaurantLocations()
            restoLocations = .success(locs)

            if let preferrerdResto = userDefaults.string(
                forKey: GlobalConstants.StorageKeys.preferredResto)
            {
                debugPrint("Preferred resto found: \(preferrerdResto)")
                if let index = locs.firstIndex(where: { $0.endpoint == preferrerdResto }) {
                    selectedResto = index
                }
            }

            if locs.count > 0 {
                await loadMeals()
            }
        } catch {
            if let hydraError = error as? HydraError {
                restoLocations = .failure(hydraError)
            } else {
                restoLocations = .failure(
                    HydraError.runtimeError("Failed to load restaurant locations", error))
            }
        }
    }

    @MainActor
    func selectResto(_ index: Int) {
        selectedResto = index
        Task {
            await loadMeals()
        }
    }
    
    @MainActor
    func loadAllergens() async {
        do {
            let allergens = try await hydraService.loadAllergens()
            self.allergens = .success(allergens)
        } catch {
            if let hydraError = error as? HydraError {
                additionalMenuItems = .failure(hydraError)
            } else {
                additionalMenuItems = .failure(
                    HydraError.runtimeError("Failed to load allergens", error))
            }
        }
    }

    @MainActor
    func loadAdditionalMenuItems() async {
        additionalMenuItems = .fetching
        do {
            let sandwiches = try await hydraService.loadSandwiches()
            let salads = try await hydraService.loadSalads()
            var extraFoodDict = try await hydraService.loadExtraFood()
            extraFoodDict["Broodjes"] = sandwiches.map { $0.intoOtherMenuItem(allergens: getAllergensForKey(type: "belegde broodjes", for: $0.name.lowercased())) }
            extraFoodDict["Salades"] = salads.map { $0.intoOtherMenuItem(allergens: getAllergensForKey(type: "saladbar", for: $0.name.lowercased())) }
            additionalMenuItems = .success(OrderedDictionary(uniqueKeysWithValues: extraFoodDict.sorted { $0.key < $1.key }))

        } catch {
            if let hydraError = error as? HydraError {
                additionalMenuItems = .failure(hydraError)
            } else {
                additionalMenuItems = .failure(
                    HydraError.runtimeError("Failed to load additional menu items", error))
            }
        }
    }

    @MainActor
    private func loadMeals() async {
        selectedRestoMenus = .fetching
        do {
            guard let endpoint = selectedRestoLocation?.endpoint else {
                return
            }

            let menus = try await hydraService.loadRestaurantMenus(for: endpoint)
            selectedRestoMenus = .success(menus)
        } catch {
            if let hydraError = error as? HydraError {
                restoLocations = .failure(hydraError)
            } else {
                restoLocations = .failure(
                    HydraError.runtimeError("Failed to load restaurant locations", error))
            }
        }
    }
    
    private func getAllergensForKey(type: String, for food: String) -> [String]? {
        guard case .success(let allergens) = allergens else {
            return nil
        }
        return allergens[type]?[food]
    }
}

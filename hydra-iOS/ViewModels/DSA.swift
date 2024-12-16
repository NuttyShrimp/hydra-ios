//
//  Associations.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/10/2024.
//

import Foundation

class DSA: ObservableObject {
    @Published private(set) var associations = AssociationsHolder()

    @MainActor
    func loadAssocations() async {
        do {
            try await associations.fetch()
        } catch {
            debugPrint("Failed to load DSA Assocations \(error)")
        }
    }

    nonisolated func getForName(_ name: String) -> Association {
        var association = associations.getByAbbreviation(name)
        if association == nil {
            debugPrint("Assocation with name: \(name) not found in dsa list")
            association = associations.createUnknown(name)
        }
        return association!
    }
}

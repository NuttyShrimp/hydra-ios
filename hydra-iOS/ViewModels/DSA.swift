//
//  Associations.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/10/2024.
//

import Foundation

class DSA: ObservableObject {
    let service: DSAService = DSAService();
    @Published private(set) var associations: HydraDataFetch<[Association]> = .fetching

    @MainActor
    func loadAssocations() async {
        associations = .fetching
        do {
            let data = try await service.fetchAssocations()
            associations = .success(data)
        } catch {
            if let hydraError = error as? HydraError {
                associations = .failure(hydraError)
            } else {
                associations = .failure(HydraError.runtimeError("Failed to load associations", error))
            }
        }
    }
    
    func getForName(_ name: String) -> Association {
        var association = getByAbbreviation(name)
        if association == nil {
            debugPrint("Assocation with name: \(name) not found in dsa list")
            association = createUnknown(name)
        }
        return association!
    }
    
    private func getByAbbreviation(_ abbr: String) -> Association? {
        if case .success(let data) = associations {
            return data.first { assocation in
                assocation.abbreviation == abbr
            }
        }
        return nil
    }
    
    private func createUnknown(_ name: String) -> Association {
        Association(abbreviation: "Unknown", name: name, description: "Onbekende vereniging", email: nil, logo: nil, website: nil)
    }
}

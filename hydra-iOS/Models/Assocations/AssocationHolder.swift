//
//  AssocationHolder.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

struct AssociationsHolder {
    private(set) var associations: [Association] = []
    
    @MainActor
    mutating func fetch() async throws {
        let url = URL(string: "\(GlobalConstants.DSA)/verenigingen")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try CustomDecoder().decode(AssociationResponse.self, from: data)
        associations = response.associations
        debugPrint("Loaded \(associations.count) assocations from DSA API")
    }
    
    
    func getByAbbreviation(_ abbr: String) -> Association? {
        associations.first { assocation in
            assocation.abbreviation == abbr
        }
    }
    
    func createUnknown(_ name: String) -> Association {
        Association(abbreviation: "Unknown", name: name, description: "Onbekende vereniging", email: nil, logo: nil, website: nil)
    }
}

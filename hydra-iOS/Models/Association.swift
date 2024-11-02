//
//  Association.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/10/2024.
//

import Foundation

struct Association: Identifiable, Decodable {
    var abbreviation: String
    var name: String
    var description: String?
    var email: String?
    var logo: URL?
    var website: URL?
    
    var id: String {
        name
    }
}

struct AssociationResponse: Decodable {
    var associations: [Association]
}

struct Associations {
    private(set) var associations: [Association] = []
    
    mutating func fetch() async throws {
        let url = URL(string: "\(Constants.DSA)/verenigingen")!
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

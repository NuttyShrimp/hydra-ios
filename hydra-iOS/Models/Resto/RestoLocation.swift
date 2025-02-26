//
//  RestoLocation.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

struct RestoLocation: Decodable, Identifiable {
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let type: String
    let endpoint: String?
    
    var id: String {
        name
    }
}

struct RestoLocationResponse: Decodable {
    var locations: [RestoLocation]
}


//
//  SpecialEventResponse.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

struct SpecialEventResponse: Decodable {
    var specialEvents: [SpecialEvent]
    
    enum CodingKeys: String, CodingKey {
        case specialEvents = "special-events"
    }
}

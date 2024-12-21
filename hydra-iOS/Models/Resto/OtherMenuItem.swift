//
//  OtherMenuItem.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 12/12/2024.
//

struct OtherMenuItem: Identifiable, Decodable {
    var name: String
    var price: String
    var description: String?
    var allergens: [String]?
    
    var id: String { name }
}

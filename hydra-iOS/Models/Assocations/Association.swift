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


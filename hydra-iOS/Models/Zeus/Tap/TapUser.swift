//
//  TapUser.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 09/04/2025.
//

import Foundation

struct TapUser: Identifiable, Decodable {
    var id: Int;
    var name: String;
    var dagschotelId: Int?;
    var ordersCount: Int;
    var admin: Bool;
    var createdAt: String;
    var updatedAt: String;
}

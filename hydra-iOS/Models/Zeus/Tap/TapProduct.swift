//
//  TapProduct.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 23/02/2025.
//

import Foundation

let TAB_IMAGE_FORMAT = "system/products/avatars/%d/%d/%d/medium/%s"

struct TapProduct: Identifiable, Decodable, Hashable {
    var id: Int
    var name: String
    var priceCents: Int
    var createdAt: String // ISO8601 with milliseconds
    var updatedAt: String // ISO8601 with milliseconds
    var avatarFileName: String?
    var avatarContentType: String?
    var avatarFileSize: Int?
    var avatarUpdatedAt: String? // ISO8601 with milliseconds
    var category: TapProductCategory
    var stock: Int
    var calories: Int?
    var deleted: Bool
    
    var avatarURL: URL? {
        guard let avatarFileName = avatarFileName else {
            return nil
        }
        // Padded ID (9 digits)
        let paddedID = String(id).leftPadding(toLength: 9, withPad: "0")
        let thirdIdx = paddedID.index(paddedID.startIndex, offsetBy: 3)
        let sixthIdx = paddedID.index(paddedID.startIndex, offsetBy: 6)
        let first = String(paddedID[..<thirdIdx])
        let second = String(paddedID[thirdIdx..<sixthIdx])
        let third = String(paddedID[sixthIdx...])
        return URL(string: GlobalConstants.TAP + "/system/products/avatars/\(first)/\(second)/\(third)/medium/\(avatarFileName)")
                
    }
}

enum TapProductCategory: String, CaseIterable, Decodable {
    case food, beverages, other
}

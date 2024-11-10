//
//  UgentNews.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 14/10/2024.
//

import Foundation

struct UGentNewsEvent: Decodable, Identifiable, Eventable {
    let id: String
    let type: EventType = .UGent
    let title: String
    let summary: String
    let content: String
    let link: URL
    let published: Date
    let updated: Date

    var eventDate: Date {
        published
    }

    func priority() -> Int {
        let hoursFromLastUpdate = Int(
            Date.now.timeIntervalSince(updated) / 60 / 60)
        return priorityLerp(hoursFromLastUpdate, 0, 14 * 24)
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, title, summary, content, link, published, updated
    }
}


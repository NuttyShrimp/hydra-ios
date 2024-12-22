//
//  SpecialEvent.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

struct SpecialEvent: Decodable, Identifiable, Eventable {
    var id: String = ""
    let type: EventType = .SpecialEvent
    // The id we get from the API
    let entryId: Int;
    let name: String;
    let link: URL;
    let simpleText: String;
    let image: URL?;
    let apiPriority: Int;
    let start: Date;
    let end: Date;

    var eventDate: Date {
        start
    }
    
    func priority() -> Int {
        GlobalConstants.Priority.FEED_MAX_PRIORITY - apiPriority - 2 * GlobalConstants.Priority.FEED_SPECIAL_OFFSET
    }
    
    enum CodingKeys: String, CodingKey {
        case name, link, start, end, image
        case simpleText = "simple-text"
        case entryId = "id"
        case apiPriority = "priority"
    }
}

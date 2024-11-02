//
//  DSAEvent.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import Foundation

struct DSAEvent: Decodable, Identifiable, Eventable {
    // This is normally a int in the API but we want to use a string so we can distinguish it better with our other news events
    var id: String = "";
    public let entryId: Int;
    public let title: String;
    public let description: String?;
    public let association: String;
    public let address: String?;
    public let infolink: String?;
    public let location: String?;
    public let startTime: Date;
    public let endTime: Date?;
    
    mutating func updateId(_ id: String) {
        self.id = id
    }
    
    var eventDate: Date {
        startTime
    }
    
    private enum CodingKeys : String, CodingKey {
            case title, description, association, address, infolink, location, startTime, endTime, entryId = "id"
        }
}

struct DSAResponse: Decodable {
    public var page: DSAPage;
}

struct DSAPage: Decodable {
    public var entries: [DSAEvent]
}

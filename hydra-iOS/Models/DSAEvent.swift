//
//  DSAEvent.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import Foundation

struct DSAEvent : Decodable, Identifiable, IntoNewsEvent {
    public let id: Int;
    public let title: String;
    public let description: String?;
    public let association: String;
    public let address: String?;
    public let infolink: String?;
    public let location: String?;
    public let start_time: Date;
    public let end_time: Date?;
    
    func intoNewsEvent() -> NewsEvent {
        return NewsEvent(id: "DSA-\(self.id)", title: self.title, description: self.description, image: nil, creationDate: start_time, finishDate: end_time, url: infolink != nil ? URL(string: infolink!) : nil)
    }
}

struct DSAResponse: Decodable {
    public var page: DSAPage;
}

struct DSAPage: Decodable {
    public var entries: [DSAEvent]
}

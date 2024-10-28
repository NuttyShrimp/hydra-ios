//
//  NewsEvent.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 14/10/2024.
//

import Foundation

struct NewsEvent: Identifiable {
    // TODO: Currently forced to use Int, adds headache if it is a ObjectIdentifier which is currently not prio
    public let id: String;
    public let title: String;
    public let description: String?;
    public let image: URL?;
    public let creationDate: Date;
    public let finishDate: Date?;
    public let url: URL?;
}

protocol IntoNewsEvent {
    func intoNewsEvent() -> NewsEvent
}

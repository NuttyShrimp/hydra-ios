//
//  UgentNews.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 14/10/2024.
//

import Foundation

struct UgentNewsEntry: Decodable, Identifiable, Eventable {
    let id: String
    let title: String
    let summary: String
    let content: String
    let link: URL
    let published: Date
    let updated: Date
    
    var eventDate: Date {
        published
    }
}

struct UgentNewsResponse: Decodable {
    var entries: [UgentNewsEntry]
}

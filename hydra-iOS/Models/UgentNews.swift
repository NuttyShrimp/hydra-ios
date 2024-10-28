//
//  UgentNews.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 14/10/2024.
//

import Foundation

struct UgentNewsEntry: Decodable{
    let id: String
    let title: String
    let summary: String
    let content: String
    let link: URL
    let published: Date
    let updated: Date
    
    func intoNewsEvent() -> NewsEvent {
        return NewsEvent(id: "Ugent-\(self.id)", title: self.title, description: self.summary, image: nil, creationDate: published, finishDate: nil, url: link)
    }
}

struct UgentNewsResponse: Decodable {
    var entries: [UgentNewsEntry]
}

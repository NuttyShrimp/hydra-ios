//
//  EventProtocol.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 29/10/2024.
//

import Foundation

protocol Eventable: Identifiable, Sendable {
    var id: String { get }
    var eventDate: Date { get }
    var type: EventType { get }
    
    func priority() -> Int
}


protocol EventService: Sendable {
    associatedtype T: Eventable, Decodable
    
    
    func fetchEvents() async throws -> [T]
}

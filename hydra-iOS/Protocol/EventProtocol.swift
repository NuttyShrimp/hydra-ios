//
//  EventProtocol.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 29/10/2024.
//

import Foundation

protocol Eventable: Identifiable {
    var id: String { get }
    var eventDate: Date { get }
    var type: EventType { get }
    
    func priority() -> Int
}

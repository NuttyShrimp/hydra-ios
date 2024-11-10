//
//  Date.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

extension Date {
    func isBefore(_ date: Date) -> Bool {
        self.compare(date) == .orderedAscending ? true : false
    }
    
    func isAfter(_ date: Date) -> Bool {
        self.compare(date) == .orderedDescending ? true : false
    }
}

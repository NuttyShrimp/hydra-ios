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

    // https://stackoverflow.com/questions/25533147/get-day-of-week-using-nsdate#35006174
    func dayOfWeek() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
}

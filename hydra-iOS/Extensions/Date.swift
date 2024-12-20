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
    func relativeDayOfWeek() -> String {
        // Show today if is same as today but before 9pm
        if Calendar.current.isDateInToday(self) {
            let now = Date()
            let ninePM = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: now)!
            if self.isBefore(ninePM) {
                return "Vandaag"
            }
            return "Morgen"
        }
        if Calendar.current.isDateInTomorrow(self) {
            return "Morgen"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let relDate = dateFormatter.string(from: self).capitalized
        
        // If these is a sunday between self and now add "next" to the day
        let now = Date()
        let nextSunday = Calendar.current.nextDate(after: now, matching: DateComponents(weekday: 1), matchingPolicy: .nextTime)
        if let sunday = nextSunday {
            let nextNextSunday = Calendar.current.nextDate(after: sunday, matching: DateComponents(weekday: 1), matchingPolicy: .nextTime)
            
            if let nextSunday = nextNextSunday, self.isBefore(nextSunday) && !self.isAfter(sunday) {
                return "Volgende \(relDate.lowercased())"
            } else {
                dateFormatter.dateFormat = "d MMM yyyy"
                return dateFormatter.string(from: self)
            }
            
        }
        return relDate
    }
}

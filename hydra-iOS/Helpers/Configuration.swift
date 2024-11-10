//
//  Configuration.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

enum Configuration {
    static var EventFeedShowPriority: Bool {
        string(for: "EVENT_FEED_SHOW_PRIORITY") == "YES"
    }
    
    static private func string(for key: String) -> String {
        Bundle.main.infoDictionary?[key] as! String
    }
}

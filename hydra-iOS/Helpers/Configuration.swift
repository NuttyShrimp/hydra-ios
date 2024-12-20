//
//  Configuration.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 10/11/2024.
//

import Foundation

enum Configuration {
    // Show the priority for each event in the feed
    static var EventFeedShowPriority: Bool {
        string(for: "EVENT_FEED_SHOW_PRIORITY") == "YES"
    }
    
    // Shows all specials regardless of the start & end date
    static var EventFeedShowAllSpecials: Bool {
        string(for: "EVENT_FEED_SHOW_ALL_SPECIALS") == "YES"
    }
    
    static var CountlyHost: String {
        string(for: "COUNTLY_HOST")
    }
    
    static var CountlyAppId: String {
        string(for: "COUNTLY_APP_ID")
    }
    
    static private func string(for key: String) -> String {
        Bundle.main.infoDictionary?[key] as! String
    }
}

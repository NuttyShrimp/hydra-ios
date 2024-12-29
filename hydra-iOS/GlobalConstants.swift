//
//  Constants.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 13/10/2024.
//

import Foundation

struct GlobalConstants {
    public static let DSA = "https://dsa.ugent.be/api";
    
    public static let ZEUS_V1 = "https://hydra.ugent.be/api/1.0";
    public static let ZEUS_V2 = "https://hydra.ugent.be/api/2.0";
    
    public static let LIBRARY = "https://widgets.lib.ugent.be";
    
    public static let TAP = "https://tap.zeus.gent";
    public static let TAB = "https://tab.zeus.gent/api/v1";
    public static let KELDER = "https://kelder.zeus.ugent.be"
    public static let MATTERMORE = "https://mattermore.zeus.gent"
    
    struct Priority {
        static let FEED_SPECIAL_OFFSET = 10;
        static let FEED_MAX_PRIORITY = 1000;
    }
    
    struct StorageKeys {
        static let crashlytics = "crashlyticsEnabled"
        static let analytics = "analyticsEnabled"
        static let preferredResto = "preferredResto"
        static let onboarding = "finishedOnboarding"
        static let allergens = "showAllergens"
        struct Zeus {
            static let enabled = "zeusModeEnabled"
            static let onboarding = "zeusOnboarding"
            static let tab = "zeusTabApiKey"
            static let tap = "zeusTapApiKey"
            static let username = "zeusUsername"
            static let door = "zeusDoorApiKey"
        }
    }
}

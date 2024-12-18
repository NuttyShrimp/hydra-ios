//
//  AnalyticsDocument.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 17/12/2024.
//

import Countly
import Foundation

class AnalyticsDocument: ObservableObject {
    var userDefaults = UserDefaults.standard
    @Published var crashlyticsEnabled = UserDefaults.standard.bool(forKey: "crashlyticsEnabled") {
        didSet {
            UserDefaults.standard.set(crashlyticsEnabled, forKey: "crashlyticsEnabled")
            setupConsents()
        }
    }
    @Published var analyticsEnabled = UserDefaults.standard.bool(forKey: "analyticsEnabled") {
        didSet {
            UserDefaults.standard.set(crashlyticsEnabled, forKey: "analyticsEnabled")
            setupConsents()
        }
    }

    func setupAnalyticsService() {
        let config: CountlyConfig = CountlyConfig()
        config.appKey = "0ffe9799d8d143106af452774e8c2c4d873461af"
        config.host = "http://localhost:7080"
        // Disable location tracking as we don't care about this
        config.disableLocation = true

        Countly.sharedInstance().start(with: config)
        setupConsents()
    }

    private func setupConsents() {
        let cInstance = Countly.sharedInstance()
        if crashlyticsEnabled {
            cInstance.giveConsent(forFeatures: [.crashReporting])
        } else {
            cInstance.cancelConsent(forFeature: .crashReporting)
        }
        
        if analyticsEnabled {
            cInstance.giveConsent(forFeatures: [.events, .sessions, .viewTracking])
        } else {
            cInstance.cancelConsent(forFeatures: [.events, .sessions, .viewTracking])
        }

    }
}

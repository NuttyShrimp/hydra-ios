//
//  Navigation.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 11/10/2024.
//

import Foundation
import Countly

class Navigation: ObservableObject {
    @Published private var selectedTab: MainTabs = .events
    
    init() {
        Countly.sharedInstance().views().startView(selectedTab.rawValue)
    }
    
    var currentTab: MainTabs {
        get {
            selectedTab
        }
        set (tab) {
            selectedTab = tab
        }
    }
    
    @MainActor
    func selectTab(_ tab: MainTabs) {
        Countly.sharedInstance().views().stopView(withName: selectedTab.rawValue)
        Countly.sharedInstance().views().startView(tab.rawValue)
        selectedTab = tab
    }
}

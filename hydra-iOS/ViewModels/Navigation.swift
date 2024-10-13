//
//  Navigation.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 11/10/2024.
//

import Foundation

class Navigation: ObservableObject {
    @Published private var tabs = Tabs();
    
    var currentTab: Int {
        get {
            tabs.selectedTab
        }
        set (tab) {
            tabs.setSelectedTab(tab)
        }
    }
    
    func selectTab(_ tab: Int) {
        tabs.setSelectedTab(tab)
    }
}

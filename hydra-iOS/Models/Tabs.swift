//
//  Tabs.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 11/10/2024.
//

import Foundation

struct Tabs {
    private(set) var selectedTab: Int
    
    init() {
        self.selectedTab = 0;
    }
    
    mutating func setSelectedTab(_ tab: Int) {
        selectedTab = tab;
    }
}

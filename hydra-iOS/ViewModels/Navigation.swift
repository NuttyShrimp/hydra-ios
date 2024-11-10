//
//  Navigation.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 11/10/2024.
//

import Foundation

@MainActor
class Navigation: ObservableObject {
    @MainActor @Published private var selectedTab: Int = 0
    
    var currentTab: Int {
        get {
            selectedTab
        }
        set (tab) {
            selectedTab = tab
        }
    }
    
    func selectTab(_ tab: Int) {
        selectedTab = tab
    }
}

//
//  hydra_iOSApp.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 07/10/2024.
//

import SwiftUI

@main
struct hydra_iOSApp: App {
    @StateObject var nav = Navigation()
    
    var body: some Scene {
        WindowGroup {
            NavigationView(navigationModel: nav)
        }
    }
}

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
    @ObservedObject var analytics = AnalyticsDocument()

    var body: some Scene {
            WindowGroup {
                if #available(iOS 17.0, *) {
                    NavigationView(navigationModel: nav)
                    .environmentObject(AnalyticsDocument())
                } else {
                    NavigationView(navigationModel: nav)
                    .environmentObject(AnalyticsDocument())
                }
            }
    }
}

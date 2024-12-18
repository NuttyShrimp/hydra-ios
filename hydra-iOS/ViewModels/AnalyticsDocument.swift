//
//  AnalyticsDocument.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 17/12/2024.
//

import Foundation

class AnalyticsDocument: ObservableObject {
    @Published var sentryEnabled = false
    @Published var fathomEnabled = false
}

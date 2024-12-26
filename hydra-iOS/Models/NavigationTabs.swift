//
//  NavigationTabs.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 18/12/2024.
//

enum MainTabs: String, Hashable {
    case events, resto, info, settings

    var icon: String {
        switch self {
        case .events:
            return "newspaper.fill"
        case .resto:
            return "fork.knife"
        case .info:
            return "info"
        case .settings:
            return "gear"
        }
    }

    var title: String {
        switch self {
        case .events:
            return "Nieuws"
        case .resto:
            return "Resto"
        case .info:
            return "Info"
        case .settings:
            return "Instellingen"
        }
    }
}

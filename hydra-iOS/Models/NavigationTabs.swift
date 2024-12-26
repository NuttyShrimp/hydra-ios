//
//  NavigationTabs.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 18/12/2024.
//

enum MainTabs: String, Hashable {
    case events, resto, info, settings, zeus

    var icon: String? {
        switch self {
        case .events:
            return "newspaper.fill"
        case .resto:
            return "fork.knife"
        case .info:
            return "info"
        case .settings:
            return "gear"
        default:
            return nil
        }
    }

    var image: String? {
        switch self {
        case .zeus:
            return "ZeusLogo"
        default:
            return nil
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
        case .zeus:
            return "Zeus"
        case .settings:
            return "Instellingen"
        }
    }
}

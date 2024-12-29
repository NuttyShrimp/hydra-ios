//
//  CammieCommand.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 27/12/2024.
//

import Foundation

enum ZeusCommand: Hashable {
    case cammie(CammieCommand)
    case message

    var icon: String {
        switch self {
        case .cammie(let command):
            return command.icon
        default:
            return "message"
        }
    }

    var label: String {
        switch self {
        case .cammie(let command):
            return command.rawValue.replacing(#/([A-Z])/#) { match in " \(match.output.0)" }
                .capitalized
        case .message:
            return "Message"
        }
    }
}

protocol ZeusCommandable: Hashable {
    func intoCommand() -> ZeusCommand
}

enum CammieCommand: String, ZeusCommandable, Hashable {
    case northWest, north, northEast, west, east, southWest, south, southEast, bigTable, smallTable,
        sofa, door

    var command: String {
        switch self {
        case .bigTable, .smallTable, .sofa, .door:
            return "set_pos"
        default:
            return "set_relative_pos"
        }
    }

    var icon: String {
        switch self {
        case .northWest: return "arrow.up.left"
        case .north: return "arrow.up"
        case .northEast: return "arrow.up.right"
        case .west: return "arrow.left"
        case .east: return "arrow.right"
        case .southWest: return "arrow.down.left"
        case .south: return "arrow.down"
        case .southEast: return "arrow.down.right"
        default: return ""
        }
    }

    var coordinate: (Int, Int) {
        switch self {
        case .bigTable:
            return (32, 6)
        case .smallTable:
            return (43, 15)
        case .sofa:
            return (64, 10)
        case .door:
            return (30, 4)
        default:
            return self.relativeCoordinate
        }
    }

    private var relativeCoordinate: (Int, Int) {
        var x: Int = 0
        var y: Int = 0
        let command = self.rawValue.lowercased()

        if command.contains("north") {
            y = 10
        } else if command.contains("south") {
            y = -10
        }

        if command.contains("east") {
            x = 10
        } else if command.contains("west") {
            x = -10
        }

        return (x, y)
    }

    func intoCommand() -> ZeusCommand {
        ZeusCommand.cammie(self)
    }

    func moveCamera() async throws {
        let coords = self.coordinate
        var url = URL(string: "\(GlobalConstants.KELDER)/webcam/cgi/ptdc.cgi")!
        url.append(queryItems: [
            URLQueryItem(name: "command", value: self.command),
            URLQueryItem(name: "posX", value: String(coords.0)),
            URLQueryItem(name: "posY", value: String(coords.1)),
        ])

        let _ = try await URLSession.shared.data(from: url)
    }
}

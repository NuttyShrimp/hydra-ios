//
//  ZeusDoorCommand.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 28/12/2024.
//

import Foundation
import AlertToast

struct ZeusDoorHandler {
    func hasDoorToken() -> Bool {
        return ZeusConfig.sharedInstance.doorToken != nil
    }

    func execute(_ command: Command) async throws {
        guard let doorToken = ZeusConfig.sharedInstance.doorToken else {
            return
        }
        let url = URL(
            string:
                "\(GlobalConstants.MATTERMORE)/api/door/\(doorToken)/\(command == .open ? "open" : "lock")"
        )!
        var request = URLRequest(url: url)
        request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"

        let _ = try await URLSession.shared.data(for: request)
    }

    enum Command {
        case open, close
    }
}

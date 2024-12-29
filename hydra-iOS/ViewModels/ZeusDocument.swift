//
//  ZeusDocument.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 26/12/2024.
//

import Foundation

typealias ZeusDoorCommand = ZeusDoorHandler.Command

class ZeusDocument: ObservableObject {
    @Published private var door = ZeusDoorHandler()
    @Published var showMessageAlert = false

    func hasDoorControl() -> Bool {
        return door.hasDoorToken()
    }

    func executeCommand(_ command: ZeusCommand) {
        switch command {
        case .cammie(let command):
            Task {
                do {
                    try await command.moveCamera()
                } catch {
                    debugPrint("Failed to move camera: \(error)")
                }
            }
        case .message:
            showMessageAlert = true
        }
    }

    @MainActor
    func sendKelderMessage(_ message: String) {
        Task {
            do {
                let url = URL(string: "\(GlobalConstants.KELDER)/messages/")!
                var request = URLRequest(url: url)
                request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = message.data(using: .utf8)
                if let username = ZeusConfig.sharedInstance.username {
                    request.setValue(username, forHTTPHeaderField: "X-Username")
                }

                let _ = try await URLSession.shared.data(for: request)
            } catch {
                debugPrint("Failed to send message to kelder: \(error)")
            }
        }
    }

    @MainActor
    func controlDoor(_ cmd: ZeusDoorCommand) async {
        do {
            try await door.execute(cmd)
        } catch {
            debugPrint("Failed to execute door command: \(error)")
        }
    }

        }
    }
}

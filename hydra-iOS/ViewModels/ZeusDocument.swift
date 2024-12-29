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
    @Published private(set) var user: CombinedUser? = nil
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

    @MainActor
    func loadUser() async {
        do {
            let tapUser = try await TapUserRequest.fetch()
            let tabUser = try await TabUserRequest.fetch()
            user = CombinedUser(
                id: tapUser.id,
                name: tapUser.name,
                balance: tabUser.balance,
                orders: tapUser.orderCount,
                favouriteOrder: tapUser.favorite)

        } catch {
            debugPrint("Failed to load user: \(error)")
        }
    }

    struct CombinedUser {
        var id: Int
        var name: String
        var balance: Int
        var orders: Int
        var favouriteOrder: Int

        func balanceDecimal() -> Double {
            return Double(balance) / 100
        }
    }
}

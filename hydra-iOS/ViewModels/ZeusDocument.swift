//
//  ZeusDocument.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 26/12/2024.
//

import Foundation

class ZeusDocument: ObservableObject {
    @Published var user: HydraDataFetch<CombinedUser?> = .fetching
    @Published var doorState: HydraDataFetch<Any?> = .idle
    @Published var messageState: HydraDataFetch<Any?> = .idle
    @Published var showMessageAlert = false

    let mattermoreService = MattermoreService()
    let kelderService = KelderService()
    
    func hasDoorControl() -> Bool {
        return ZeusConfig.sharedInstance.doorToken != nil
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
    func sendKelderMessage(_ message: String) async {
        messageState = .fetching
        do {
            try await kelderService.sendKelderMessage(message: message)
            messageState = .success(nil)
        } catch {
            if let hydraError = error as? HydraError {
                messageState = .failure(hydraError)
            } else {
                messageState = .failure(HydraError.runtimeError("Failed to send message", error))
            }
        }
    }

    @MainActor
    func controlDoor(_ cmd: DoorCommand) async {
        doorState = .fetching
        do {
            guard let doorToken = ZeusConfig.sharedInstance.doorToken else {
                throw HydraError.runtimeError("Door token not set")
            }
            try await mattermoreService.executeDoorAction(
                token: doorToken, action: cmd == .open ? "open" : "lock")
            doorState = .success(nil)
        } catch {
            if let hydraError = error as? HydraError {
                doorState = .failure(hydraError)
            } else {
                doorState = .failure(HydraError.runtimeError("Failed to send door command", error))
            }
        }
    }

    @MainActor
    func loadUser() async {
        do {
            let tapUser = try await TapUserRequest.fetch()
            let tabUser = try await TabUserRequest.fetch()
            user = .success(
                CombinedUser(
                    id: tapUser.id,
                    name: tapUser.name,
                    balance: tabUser.balance,
                    orders: tapUser.orderCount,
                    favouriteOrder: tapUser.favorite)
            )

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

    enum DoorCommand {
        case open, close
    }
}

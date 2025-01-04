//
//  ZeusDocument.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 26/12/2024.
//

import Foundation

class ZeusDocument: ObservableObject {
    @Published var user: HydraDataFetch<TabUserRequest.TabUser> = .idle
    @Published var doorState: HydraDataFetch<Any?> = .idle
    @Published var messageState: HydraDataFetch<Any?> = .idle
    @Published var tabRequests: HydraDataFetch<[TabTransaction]> = .idle
    @Published var tabTransaction: HydraDataFetch<[TabTransaction]> = .idle
    @Published var showMessageAlert = false
    @Published var tabRequestAction: HydraDataFetch<Any?> = .idle

    let mattermoreService = MattermoreService()
    let kelderService = KelderService()
    let tabService = TabService()
    
    
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
    func executeRequestAction(for id: Int, action: RequestAction) async {
        tabRequestAction = .fetching
        do {
             guard let tabToken = ZeusConfig.sharedInstance.tabToken else {
                throw HydraError.runtimeError("Tab token not set")
            }

            _ = try await tabService.postTabAction(for: id, action: action.rawValue, tabKey: tabToken)
            tabRequestAction = .success("Request \(action.rawValue == "confirm" ? "confirmed" : "declined")")
            await loadUser()
            await loadTabRequests()
            await loadTabTransactions()
        } catch {
            if let hydraError = error as? HydraError {
                tabRequestAction = .failure(hydraError)
            } else {
                tabRequestAction = .failure(HydraError.runtimeError("Failed to get tab requests", error))
            }
        }
    }

    @MainActor
    func loadUser() async {
        do {
            let tabUser = try await TabUserRequest.fetch()
            user = .success(
                tabUser
            )
        } catch {
            debugPrint("Failed to load user: \(error)")
        }
    }
    
    @MainActor
    func loadTabRequests() async {
        tabRequests = .fetching
        do {
            guard let username = ZeusConfig.sharedInstance.username else {
                throw HydraError.runtimeError("Username not set")
            }
            guard let tabToken = ZeusConfig.sharedInstance.tabToken else {
                throw HydraError.runtimeError("Tab token not set")
            }

            let data = try await tabService.getOpenRequest(for: username, tabKey: tabToken)
            tabRequests = .success(data)
        } catch {
            if let hydraError = error as? HydraError {
                tabRequests = .failure(hydraError)
            } else {
                tabRequests = .failure(HydraError.runtimeError("Failed to get tab requests", error))
            }
        }
    }
    
    @MainActor
    func loadTabTransactions() async {
        tabTransaction = .fetching
        do {
            guard let username = ZeusConfig.sharedInstance.username else {
                throw HydraError.runtimeError("Username not set")
            }
            guard let tabToken = ZeusConfig.sharedInstance.tabToken else {
                throw HydraError.runtimeError("Tab token not set")
            }

            let data = try await tabService.getTransactions(for: username, tabKey: tabToken)
            tabTransaction = .success(data)
        } catch {
            if let hydraError = error as? HydraError {
                tabTransaction = .failure(hydraError)
            } else {
                tabTransaction = .failure(HydraError.runtimeError("Failed to get tab transactions", error))
            }
        }
    }

    enum DoorCommand {
        case open, close
    }
    
    enum RequestAction: String {
        case confirm, decline
    }
}

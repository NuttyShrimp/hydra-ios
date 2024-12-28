//
//  ZeusDocument.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 26/12/2024.
//

import Foundation

class ZeusDocument: ObservableObject {
    @Published var showMessageAlert = false
    @Published private var username = UserDefaults.standard.string(forKey: GlobalConstants.StorageKeys.Zeus.username) {
        didSet {
            UserDefaults.standard.set(username, forKey: GlobalConstants.StorageKeys.Zeus.username)
        }
    }
    @Published private var doorToken = UserDefaults.standard.string(forKey: GlobalConstants.StorageKeys.Zeus.door) {
        didSet {
            UserDefaults.standard.set(doorToken, forKey: GlobalConstants.StorageKeys.Zeus.door)
        }
    }
    
    func hasDoorControl() -> Bool {
        return doorToken != nil
    }

    func executeCommand(_ command: ZeusCommand) {
        switch command {
        case .cammie(let command):
            moveCamera(direction: command)
        case .message:
            showMessageAlert = true
        }
    }

    @MainActor
    func sendKelderMessage(_ message: String)  {
        Task {
            do {
                debugPrint("Sending message to kelder: \(message)")
                let url = URL(string: "\(GlobalConstants.KELDER)/messages/")!
                var request = URLRequest(url: url)
                request.setValue("text/plain", forHTTPHeaderField: "Content-Type")
                request.httpMethod = "POST"
                request.httpBody = message.data(using: .utf8)
                if let username = self.username {
                    request.setValue(username, forHTTPHeaderField: "X-Username")
                }
                    
                let _ = try await URLSession.shared.data(for: request)
            } catch {
                debugPrint("Failed to send message to kelder: \(error)")
            }
        }
    }

    private func moveCamera(direction: CammieCommand) {
        Task {
            do {
                let coords = direction.coordinate
                var url = URL(string: "\(GlobalConstants.KELDER)/webcam/cgi/ptdc.cgi")!
                url.append(queryItems: [
                    URLQueryItem(name: "command", value: direction.command),
                    URLQueryItem(name: "posX", value: String(coords.0)),
                    URLQueryItem(name: "posY", value: String(coords.1)),
                ])

                let _ = try await URLSession.shared.data(from: url)
            } catch {
                debugPrint("Failed to send cammie command: \(error)")
            }
        }
    }
}

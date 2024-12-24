//
//  ExtraInfo.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 24/12/2024.
//

import Foundation

class ExtraInfoDocument: ObservableObject {
    @Published private var infoApi = InfoHolder()
    
    var entries: [InfoEntry] {
        get {
            infoApi.entries
        }
        set {}
    }
    
    @MainActor
    func loadInfo() async {
        do {
            try await infoApi.load()
        } catch {
            debugPrint("Failed to load ExtraInfo \(error)")
        }
    }
}

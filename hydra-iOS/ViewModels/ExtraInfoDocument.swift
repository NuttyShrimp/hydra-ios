//
//  ExtraInfo.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 24/12/2024.
//

import Foundation

class ExtraInfoDocument: ObservableObject {
    @Published var info: HydraDataFetch<[InfoEntry]> = .fetching
    
    private let hydraService = HydraService()
    
    @MainActor
    func loadInfo() async {
        info = .fetching
        do {
            let data = try await hydraService.loadInfo()
            info = .success(data)
        } catch {
            if let hydraError = error as? HydraError {
                info = .failure(hydraError)
            } else {
                info = .failure(
                    HydraError.runtimeError("Failed to load info", error))
            }
        }
    }
}

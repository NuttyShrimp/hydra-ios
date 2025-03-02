//
//  ZeusOrderDocument.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 23/02/2025.
//

import Foundation

class ZeusOrderDocument: ObservableObject {
    @Published var products: HydraDataFetch<[TapProduct]> = .idle
    @Published var cart: [TapProduct] = []
    
    let tapService = TapService()
    
    @MainActor
    func loadAvailableProducts() async {
        do {
            guard let tapToken = ZeusConfig.sharedInstance.tapToken else {
                throw HydraError.runtimeError("Tap token not set")
            }

            let data = try await tapService.getProducts(tapKey: tapToken)
            products = .success(data)
        } catch {
            if let hydraError = error as? HydraError {
                products = .failure(hydraError)
            } else {
                products = .failure(HydraError.runtimeError("Failed to get tap products", error))
            }
        }
    }
    
    func addToCart(_ productId: Int) {
        guard case .success(let products) = products else {
            return
        }
        guard let product = products.first(where: { $0.id == productId }) else {
            return
        }
        cart.append(product)
    }
    
    func removeFromCart(_ productId: Int) {
        cart.removeAll { $0.id == productId }
    }
}

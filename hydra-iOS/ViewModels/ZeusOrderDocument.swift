//
//  ZeusOrderDocument.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 23/02/2025.
//

import Foundation
import OrderedCollections

class ZeusOrderDocument: ObservableObject {
    @Published var products: HydraDataFetch<[TapProduct]> = .idle
    @Published var tapUser: HydraDataFetch<TapUser> = .idle
    @Published var cart: [TapProduct: Int] = [:]
    var orderedCart: OrderedDictionary<TapProduct, Int> {
        return OrderedDictionary(uniqueKeys: cart.keys, values: cart.values)
    }
    
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
    
    @MainActor
    func loadTapUser() async {
        do {
            guard let tapToken = ZeusConfig.sharedInstance.tapToken else {
                throw HydraError.runtimeError("Tap token not set")
            }
            guard let username = ZeusConfig.sharedInstance.username else {
                throw HydraError.runtimeError("Username not set")
            }
            let data = try await tapService.getTapUser(tapKey: tapToken, tapUsername: username)
            tapUser = .success(data)
        } catch {
            if let hydraError = error as? HydraError {
                tapUser = .failure(hydraError)
            } else {
                tapUser = .failure(HydraError.runtimeError("Failed to get tap user", error))
            }
        }
    }
    
    func addDagschotelToCart() {
        guard case .success(let tapUser) = tapUser else {
            print("Tap user not loaded successfully")
            return
        }
        guard let productId = tapUser.dagschotelId else {
            return
        }
        addToCart(productId)
    }
    
    func addToCart(_ productId: Int) {
        guard case .success(let products) = products else {
            return
        }
        guard let product = products.first(where: { $0.id == productId }) else {
            print("Product with id \(productId) not found in available products")
            return
        }
        if cart.keys.contains(product) {
            cart[product]! += 1
        } else {
            cart[product] = 1
        }
    }
    
    func removeFromCart(_ productId: Int) {
        cart = cart.filter { $0.key.id != productId }
    }
    
    @MainActor
    func confirmOrder() async {
        do {
            guard case .success(let tapUser) = tapUser else {
                return
            }
            guard let tapToken = ZeusConfig.sharedInstance.tapToken else {
                return
            }
            try await tapService.addOrder(tapKey: tapToken, tapUsername: tapUser.name, cart: cart)
        } catch {
            
        }
    }
}

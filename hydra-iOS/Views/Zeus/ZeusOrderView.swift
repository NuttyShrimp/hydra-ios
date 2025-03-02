//
//  ZeusOrderView.swift
//  hydra-iOS
//
//  Created by Jan Lecoutere on 23/02/2025.
//

import SwiftUI

struct ZeusOrderView: View {
    @ObservedObject var order: ZeusOrderDocument
    @State private var showProducts = false
    @State private var productFilter = ""

    var body: some View {
        DataLoaderView(order.products, fetcher: order.loadAvailableProducts) { _ in
            List {
                ForEach(order.cart) { product in
                    ZeusProductView(order: order, product: product, actions: [.removeFromCart])
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        // Add dagschotel
                    } label: {
                        Label("Add dagschotel", systemImage: "star.fill")
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showProducts.toggle()
                    } label: {
                        Label("Add product", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showProducts) {
                ZeusProductSelectionView(order: order)
                    .padding(.vertical)
                    .padding(.horizontal, 5)
            }
        }
    }
}

struct ZeusProductSelectionView: View {
    @ObservedObject var order: ZeusOrderDocument
    @State private var productFilter = ""

    var body: some View {
        NavigationStack {
            if case .success(let products) = order.products {
                let filteredProducts =
                productFilter.isEmpty
                ? products
                : products.filter { product in
                    product.name.lowercased().contains(productFilter.lowercased())
                }
                List {
                    ForEach(filteredProducts) { product in
                        ZeusProductView(
                            order: order, product: product, actions: [.addToCart])
                    }
                }
            }
        }
        .searchable(text: $productFilter)
    }
}

struct ZeusProductView: View {
    // This can be abstracted with the enum actions
    @ObservedObject var order: ZeusOrderDocument
    var product: TapProduct
    var actions: [ZeusProductActions] = []

    var body: some View {
        HStack {
            if let avatarURL = product.avatarURL {
                HAsyncImage(url: avatarURL, size: 40)
            }
            Text(product.name)
        }
        .swipeActions(allowsFullSwipe: true) {
            ForEach(actions, id: \.self) { action in
                switch action {
                case .addToCart:
                    Button {
                        order.addToCart(product.id)
                    } label: {
                        Label("Add to cart", systemImage: "cart.fill.badge.plus")
                    }
                    .tint(.green)
                case .removeFromCart:
                    Button {
                        order.removeFromCart(product.id)
                    } label: {
                        Label("Remove from cart", systemImage: "cart.fill.badge.minus")
                    }
                    .tint(.red)
                }
            }
        }

    }
}

enum ZeusProductActions {
    case addToCart
    case removeFromCart
}

#Preview {
    ZeusOrderView(order: ZeusOrderDocument())
}

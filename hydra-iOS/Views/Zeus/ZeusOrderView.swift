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
            DataLoaderView(order.tapUser, fetcher: order.loadTapUser) { _ in
                VStack {
                    List {
                        ForEach(order.orderedCart.elements, id: \.key) { product, amount in
                            ZeusProductView(
                                order: order, isPresented: Binding.constant(false),
                                product: product,
                                actions: [.addToCart, .removeFromCart], orderAmount: amount)
                        }
                    }
                    Spacer()
                    Button(action: {
                        Task {
                            await order.confirmOrder()
                        }
                    }) {
                        Label("Maak order", systemImage: "basket").font(.system(size: 20))
                    }
                    .buttonStyle(.borderedProminent)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            order.addDagschotelToCart()
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
                    ZeusProductSelectionView(order: order, isPresented: $showProducts)
                        .padding(.vertical)
                        .padding(.horizontal, 5)
                }
            }
        }
    }
}

struct ZeusProductSelectionView: View {
    @ObservedObject var order: ZeusOrderDocument
    @Binding var isPresented: Bool
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
                            order: order, isPresented: $isPresented, product: product,
                            actions: [.addToCart])
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
    @Binding var isPresented: Bool
    var product: TapProduct
    var actions: [ZeusProductActions] = []
    var orderAmount: Int?

    var body: some View {
        VStack {
            HStack {
                if let avatarURL = product.avatarURL {
                    HAsyncImage(url: avatarURL, size: 40)
                }
                Text(product.name)
                Spacer()
                Text(product.price)
            }
            Divider()
            if let amount = orderAmount {
                Text("\(amount) in cart")
            }
        }
        .swipeActions(allowsFullSwipe: true) {
            ForEach(actions, id: \.self) { action in
                switch action {
                case .addToCart:
                    Button {
                        order.addToCart(product.id)
                        isPresented = false
                    } label: {
                        Label("Add to cart", systemImage: "cart.fill.badge.plus")
                    }
                    .tint(.green)
                case .removeFromCart:
                    Button {
                        order.removeFromCart(product.id)
                        isPresented = false
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

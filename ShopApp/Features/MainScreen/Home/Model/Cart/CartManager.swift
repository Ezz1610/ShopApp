//
//  CartManager.swift
//  ShopApp
//
//  Created by Soha Elgaly on 27/10/2025.
//


import Foundation
import SwiftUI


class CartManager: ObservableObject {
    
    static let shared = CartManager()   // Singleton
    private init() {}

    @Published var productsInCart: [ProductInCart] = []
    @Published var addToCartAlert = false
    @Published var pendingProductToRemove: ProductModel?
    @Published var showRemoveConfirmation = false
    @Published var showCheckout = false

    // MARK: - Helpers
    private func cleanPrice(_ raw: String?) -> Double {
        guard let raw = raw else { return 0.0 }
        let cleaned = raw.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        return Double(cleaned) ?? 0.0
    }

    func validPrice(for product: ProductModel) -> Double {
        let mainPrice = cleanPrice(product.price)
        if mainPrice > 0 { return mainPrice }

        let variantPrices = product.variants.map { cleanPrice($0.price) }.filter { $0 > 0 }
        return variantPrices.min() ?? 0.0
    }

    var displayTotalCartQuantity: Int {
        productsInCart.reduce(0) { $0 + $1.quantity }
    }
   
    var totalCartValueInUSD: Double {
        productsInCart.reduce(0) { sum, item in
            let price = Double(item.product.variants.first?.price ?? item.product.price) ?? 0
            return sum + (price * Double(item.quantity))
        }
    }
    var displayTotalCartPrice: String {
        let converted = totalCartValueInUSD * CurrencyManager.shared.exchangeRate
        return String(format: "%.2f %@", converted, CurrencyManager.shared.selectedCurrency)
    }
//    var displayTotalCartPrice: String {
//        let total = productsInCart.reduce(0.0) { $0 + (validPrice(for: $1.product) * Double($1.quantity)) }
//        let formatter = NumberFormatter()
//        formatter.numberStyle = .currency
//        formatter.currencySymbol = "$"
//        return formatter.string(from: NSNumber(value: total)) ?? "$0.00"
//    }

    // MARK: - Core Logic
    func addToCart(product: ProductModel) {
        var cartProduct = product
        if cartProduct.price.isEmpty {
            cartProduct.price = product.variants.first?.price ?? "0"
        }
        if cartProduct.productImage.isEmpty {
            cartProduct.productImage = product.images.first?.src ?? product.image?.src ?? ""
        }

        if let index = productsInCart.firstIndex(where: { $0.id == cartProduct.id }) {
            productsInCart[index].quantity += 1
        } else {
            productsInCart.append(ProductInCart(product: cartProduct, quantity: 1))
        }

        addToCartAlert = true
    }

    func removeFromCart(product: ProductModel) {
        if let index = productsInCart.firstIndex(where: { $0.id == product.id }) {
            if productsInCart[index].quantity > 1 {
                productsInCart[index].quantity -= 1
            } else {
                pendingProductToRemove = product
                showRemoveConfirmation = true
            }
        }
    }

    func confirmRemove() {
        if let product = pendingProductToRemove,
           let index = productsInCart.firstIndex(where: { $0.id == product.id }) {
            productsInCart.remove(at: index)
        }
        pendingProductToRemove = nil
        showRemoveConfirmation = false
    }

    func cancelRemove() {
        pendingProductToRemove = nil
        showRemoveConfirmation = false
    }

    func clearCart() {
        productsInCart.removeAll()
    }
}

//
//  CartManager.swift
//  ShopApp
//
//  Created by Soha Elgaly on 27/10/2025.
//
import Foundation
import SwiftUI

@Observable
class CartManager {
    
    var productsInCart: [ProductInCart] = []
    var addToCartAlert = false
    var pendingProductToRemove: ProductModel?
    var showRemoveConfirmation = false
    var showCheckout = false
    
    // MARK: - Helpers
    
    private func cleanPrice(_ raw: String?) -> Double {
        guard let raw = raw else { return 0.0 }
        // إزالة أي رموز غير أرقام أو نقاط (زي $ أو مسافات)
        let cleaned = raw.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)
        return Double(cleaned) ?? 0.0
    }
    
    public func validPrice(for product: ProductModel) -> Double {
        if !product.price.isEmpty {
            return cleanPrice(product.price)
        }
        return cleanPrice(product.variants.first?.price)
    }
    
    // MARK: - Computed
    
    var displayTotalCartQuantity: Int {
        productsInCart.reduce(0) { $0 + $1.quantity }
    }
    
    var displayTotalCartPrice: String {
        let total = productsInCart.reduce(0.0) { $0 + (validPrice(for: $1.product) * Double($1.quantity)) }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: total)) ?? "$0.00"
    }
    
    // MARK: - Logic
    
    func addToCart(product: ProductModel) {
        print("🛒 Added product: \(product.title) | price: \(product.price)")
        if let index = productsInCart.firstIndex(where: { $0.id == product.id }) {
            productsInCart[index].quantity += 1
        } else {
            productsInCart.append(ProductInCart(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(product: ProductModel) {
        if let index = productsInCart.firstIndex(where: { $0.id == product.id }) {
            let currentQuantity = productsInCart[index].quantity
            if currentQuantity > 1 {
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

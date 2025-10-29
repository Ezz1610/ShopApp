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
   
    var productsInCart : [ProductInCart] = []
    var addToCartAlert = false
    var pendingProductToRemove: ProductModel?
    var showRemoveConfirmation = false         
    
    var displayTotalCartQuantity: Int {
        productsInCart.reduce(0) { $0 + $1.quantity }
    }
    
    var displayTotalCartPrice: String {
        let total = productsInCart.reduce(0.0) { $0 + ((Double($1.product.variants.first?.price ?? "0") ?? 0) * Double($1.quantity)) }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: total)) ?? "$0.00"
    }


    
    
    func addToCart(product: ProductModel) {
        if let indexOfProductInCart = productsInCart.firstIndex(where: { $0.id == product.id }) {
            let currentQuantity = productsInCart[indexOfProductInCart].quantity
            let newQuantity = currentQuantity + 1
            let updatedProductInCart = ProductInCart(product: product, quantity: newQuantity)
            productsInCart[indexOfProductInCart] = updatedProductInCart
        } else {
            productsInCart.append(ProductInCart(product: product, quantity: 1))
        }
    }
    
    func removeFromCart(product: ProductModel) {
        if let indexOfProductInCart = productsInCart.firstIndex(where: { $0.id == product.id }) {
            let currentQuantity = productsInCart[indexOfProductInCart].quantity
            if currentQuantity > 1 {
                let newQuantity = currentQuantity - 1
                let updatedProductInCart = ProductInCart(product: product, quantity: newQuantity)
                productsInCart[indexOfProductInCart] = updatedProductInCart
            } else {
                // last item → ask for confirmation
                pendingProductToRemove = product
                showRemoveConfirmation = true            }
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

}

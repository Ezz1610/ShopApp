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
}

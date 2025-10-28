//
//  ProductInCart.swift
//  ShopApp
//
//  Created by Soha Elgaly on 25/10/2025.
//

import Foundation

struct ProductInCart: Identifiable {
    var id : Int {
         product.id
    }
    let product: ProductModel
    var quantity: Int
    var selectedVariant: Variant?
    
    var totalPrice: Double {
        guard let variant = selectedVariant,
              let price = Double(variant.price) else { return 0 }
        return price * Double(quantity)
    }
}
 

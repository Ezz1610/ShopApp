//
//  CartView.swift
//  ShopApp
//
//  Created by Soha Elgaly on 25/10/2025.
//

import SwiftUI

struct CartView: View {
    
    @Environment(CartManager.self) var cartManager: CartManager
    fileprivate func cartRow(productInCart: ProductInCart) -> some View {
        HStack {
            CustomNetworkImage(
                url: (productInCart.product.image?.src ?? ""),
                width: 70,
                height: 70,
                isSquared: true
            )
            VStack(alignment: .leading,spacing: 15) {
                Text(productInCart.product.title)
                    .modifier(AppTextStyle.mediumStyle())
                Text("$\(productInCart.product.variants.first?.price ?? "0.00")")
                Stepper("Quantity \(productInCart.quantity)") {
                    
                } onDecrement: {
                    
                }

            }
        }
    }
   
    
    var body: some View {
        VStack {
            Spacer()
            if (cartManager.productsInCart).isEmpty {
               
                Text("Your cart is empty.")
                    .modifier(AppTextStyle.mediumStyle())
                    .padding()
                  
            } else {
                List {
                    ForEach(cartManager.productsInCart) { productInCart in
                        cartRow(productInCart: productInCart)
                    }
                    
                }
                
            }
            Spacer()
            Button(action: {
                // Proceed to checkout action
            }) {
                Text("Proceed to Checkout")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .padding()
                
            }
            
        }
    }
}
#Preview {
    CartView()
        .environment(CartManager())
}

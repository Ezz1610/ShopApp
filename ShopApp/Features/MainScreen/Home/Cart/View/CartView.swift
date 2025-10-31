//
//  CartView.swift
//  ShopApp
//
//  Created by Soha Elgaly on 25/10/2025.
//

import SwiftUI

struct CartView: View {
    
    @Environment(CartManager.self) var cartManager: CartManager
    @State private var showCheckout = false
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
                    cartManager.addToCart(product: productInCart.product)
                } onDecrement: {
                    cartManager.removeFromCart(product: productInCart.product)
                }

            }
        }
    }
   
    
    var body: some View {
        @Bindable var cartManager = cartManager
        VStack {
            Spacer()
            if (cartManager.productsInCart).isEmpty {
                Text("Your cart is empty 👀")
                    .modifier(AppTextStyle.customStyle(fontSize: 30))
                    .padding()
            } else {
                List {
                    ForEach(cartManager.productsInCart) { productInCart in
                        cartRow(productInCart: productInCart)
                    }
                }
                VStack {
                    Divider()
                    HStack {
                        Text("Total: \(cartManager.displayTotalCartQuantity) items")
                            .font(.title2.bold())
                        Spacer()
                        Text(cartManager.displayTotalCartPrice)
                            .font(.title2.bold())
                            
                    }
                    .padding(.horizontal)
                   
                }
            }
            Spacer()
           
                Button(action: {
                    showCheckout = true
                }) {
                    Text("Proceed to Checkout")
                        .font(.headline.bold())
                        .foregroundColor(.primary)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(AppColors.primary)
                        .cornerRadius(10)
                        .padding()
                    
                }
                
                .sheet(isPresented: $showCheckout) {
                            CheckoutView()
                        }
        } .alert("Remove Last Item?",
                 isPresented: $cartManager.showRemoveConfirmation) {
              Button("OK", role: .destructive) {
                  cartManager.confirmRemove()
              }
              Button("Undo", role: .cancel) {
                  cartManager.cancelRemove()
              }
          } message: {
              Text("Are you sure to delete \(cartManager.pendingProductToRemove?.title ?? "this product") from your cart.")
          }
    }
}
#Preview {
    CartView()
        .environment(CartManager())
}

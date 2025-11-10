//
//  CartView.swift
//  ShopApp
//
//  Created by Soha Elgaly on 25/10/2025.
//


import SwiftUI

struct CartView: View {
    
    @EnvironmentObject var cartManager: CartManager 
    @EnvironmentObject var navigator: AppNavigator
    @State private var showCheckout = false
    @Bindable var currencyManager = CurrencyManager.shared
    fileprivate func cartRow(productInCart: ProductInCart) -> some View {
        let product = productInCart.product
        let price = cartManager.validPrice(for: product)

        return HStack {
            CustomNetworkImage(
                url: product.image?.src ?? product.productImage,
                width: 70,
                height: 70,
                isSquared: true
            )
            
            VStack(alignment: .leading, spacing: 8) {
                Text(product.title)
                    .modifier(AppTextStyle.mediumStyle())
                
                Text(String(currencyManager.formatPrice(price)))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Stepper("Quantity \(productInCart.quantity)") {
                    cartManager.addToCart(product: product)
                } onDecrement: {
                    cartManager.removeFromCart(product: product)
                }
            }
        }
        .padding(.vertical, 4)
    }

    var body: some View {
        VStack {
            // MARK: - Header
            HStack {
                Button(action: { navigator.goBack() }) {
                    Image(systemName: "chevron.backward")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                Spacer()
                Text("My Cart")
                    .font(.headline)
                Spacer()
            }
            .padding()
            
            // MARK: - Cart Content
            if cartManager.productsInCart.isEmpty {
                Spacer()
                Image("cart-empty")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Spacer()
            } else {
                List {
                    ForEach(cartManager.productsInCart) { productInCart in
                        cartRow(productInCart: productInCart)
                    }
                }
                .listStyle(PlainListStyle())
                
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
            
            // MARK: - Checkout Button
                if cartManager.productsInCart.isEmpty {
                    Button(action: {navigator.goTo(.homeView)}) {
                        Text("Go Shopping 🛍️")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.primary)
                            .cornerRadius(10)
                            .padding()
                    }
                } else {
                    VStack(spacing:-25) {
                    Button(action: { showCheckout = true }) {
                        Text("Proceed to Checkout")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.primary)
                            .cornerRadius(10)
                            .padding()
                    }
                    .sheet(isPresented: $showCheckout) {
                        CheckoutView()
                    }
                    Button(action: {navigator.goTo(.homeView)}) {
                        Text("Go Shopping 🛍️")
                            .font(.headline.bold())
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(AppColors.black)
                            .cornerRadius(10)
                            .padding()
                    }
                }
            }
        }
        // MARK: - Remove Confirmation Alert
        .alert("Remove Last Item?", isPresented: $cartManager.showRemoveConfirmation) {
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

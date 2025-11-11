//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 25/10/2025.
//
import SwiftUI


struct ProductDetailsView: View {
    @EnvironmentObject var navigator: AppNavigator
    @EnvironmentObject var cartManager: CartManager
    @State private var isAdded = false
    let product: ProductModel
    let navigateFrom: NavigateFrom   // ✅ New
    @Environment(\.dismiss) private var dismiss
    @Bindable var currencyManager = CurrencyManager.shared

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                // MARK: - Product Images
                TabView {
                    ForEach(product.images) { img in
                        CustomNetworkImage(
                            url: img.src,
                            width: UIScreen.main.bounds.width,
                            height: 300,
                            cornerRadius: 0
                        )
                        .frame(maxWidth: .infinity, maxHeight: 300)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(height: 300)

                // MARK: - Title
                Text(product.title)
                    .font(.title2.bold())
                    .padding(.horizontal)

                // MARK: - Price
                if let priceString = product.variants.first?.price,
                   let price = Double(priceString) {
                    let convertedPrice = price * currencyManager.exchangeRate
                    Text("\(currencyManager.getCurrencySymbol())\(String(format: "%.2f", convertedPrice))")
                        .font(.title3.bold())
                        .foregroundColor(.accentColor)
                        .padding(.horizontal)
                }

                // MARK: - Description
                Text(product.bodyHTML)
                    .font(.body)
                    .padding(.horizontal)

                // MARK: - Add to Cart Button
                Button(action: {
                    cartManager.addToCart(product: product)
                    cartManager.addToCartAlert = true
                    isAdded = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isAdded = false
                    }
                }) {
                    HStack {
                        if isAdded {
                            Image(systemName: "checkmark.circle.fill")
                        }
                        Text(isAdded ? "Added to Cart!" : "Add to Cart")
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(AppColors.black)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .padding()
                .animation(.easeInOut, value: isAdded)
            }
        }
        .toolbar {
            // MARK: - Custom Back Button
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    switch navigateFrom {
                    case .fromHome:
                        navigator.goBack()
                    case .fromCategory:
                        navigator.goTo(.mainTabView(selectedTab: 1), replaceLast: true)        
                    case .fromFavorites:
                        navigator.goTo(.favoritesView, replaceLast: true)

                    }
                }) {
                    HStack {
                        Image(systemName: "chevron.left")
                        if navigateFrom == .fromHome {
                                       Text(product.vendor)
                                           .font(.subheadline)
                                           .foregroundColor(.black)
                                           .padding(.horizontal)

                                   } else {
                                       Text(HelperFunctions.navigateFromToString(navigateFrom))
                                           .font(.subheadline)
                                           .foregroundColor(.black)
                                           .padding(.horizontal)
                                   }
                    }
                }
            }
        }
    }
}

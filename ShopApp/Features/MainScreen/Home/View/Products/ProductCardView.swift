//
//  ProductCardView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 26/10/2025.
//
import SwiftUI
import SwiftUI

struct ProductCardView: View {
    var product: ProductModel
    @ObservedObject var viewModel: HomeViewModel
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ProductImageSection(product: product, viewModel: viewModel)
            ProductInfoSection(product: product)
            AddToCartButton(product: product)
            Spacer(minLength: 0)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .frame(minHeight: 260)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 3)
        )
     
    }
}

private struct ProductImageSection: View {
    var product: ProductModel
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: URL(string: product.image?.src ?? product.productImage)) { phase in
                switch phase {
                case .empty:
                    Rectangle().fill(Color.gray.opacity(0.1))
                case .success(let image):
                    image.resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 140)
                        .clipped()
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.1))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.title3)
                                .foregroundColor(.gray)
                        )
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 140)
            .frame(maxWidth: .infinity)
            .background(Color.gray.opacity(0.05))
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))

            FavoriteButton(product: product, viewModel: viewModel)
                .padding(8)
        }
    }
}

private struct FavoriteButton: View {
    var product: ProductModel
    @ObservedObject var viewModel: HomeViewModel
    @State private var showGuestAlert = false
    @EnvironmentObject var navigator: AppNavigator

    var body: some View {
    
        Button {
            if AppViewModel.shared.isGuest {
                showGuestAlert = true
            } else {
                toggleFavoriteSafely()
            }
        } label: {
            Circle()
                .fill(.white)
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                .frame(width: 28, height: 28)
                .overlay(
                    Image(systemName: viewModel.isFavorite(product) ? "heart.fill" : "heart")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(viewModel.isFavorite(product) ? .red : .black)
                )
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.favorites)
        .alert("You must login to access this feature", isPresented: $showGuestAlert) {
            Button("Login") {
                navigator.goTo(.login, replaceLast: true)
            }
            Button("Continue as Guest", role: .cancel) {
                // يكمل كـ Guest بدون أي عملية
            }
        }

    }

    private func toggleFavoriteSafely() {
        if let safeProduct = viewModel.products.first(where: { $0.id == product.id }) ??
            viewModel.collectionProducts.first(where: { $0.id == product.id }) {
            viewModel.toggleFavorite(safeProduct)
        }
    }
}

private struct ProductInfoSection: View {
    var product: ProductModel
    @Bindable var currencyManager = CurrencyManager.shared
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(product.title)
                .font(.system(size: 13, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxHeight: 38, alignment: .top)

            let convertedPrice = product.validPrice * currencyManager.exchangeRate
            Text("\(currencyManager.getCurrencySymbol())\(String(format: "%.2f", convertedPrice))")
                .font(.system(size: 13, weight: .regular, design: .rounded))
                .foregroundColor(.secondary)
        }
    }
}

private struct AddToCartButton: View {
    @State private var showToast:Bool = false
    @State private var showGuestAlert: Bool = false

    var product: ProductModel
    @EnvironmentObject var cartManager: CartManager
    @EnvironmentObject var navigator: AppNavigator


    var body: some View {
        Button {
                    if AppViewModel.shared.isGuest {
                        showGuestAlert = true
                    } else {
                        cartManager.addToCart(product: product)
                        showToast = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showToast = false
                        }
                    }
                } label: {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.black)
                        .frame(height: 36)
                        .overlay(
                            Text("Add to Cart")
                                .font(.system(size: 13, weight: .semibold, design: .rounded))
                                .foregroundColor(.white)
                        )
                }
                .padding(.top, 4)
                .overlay(
                    VStack {
                        Spacer()
                        if showToast {
                            HStack {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundColor(.white)
                                Text("Added")
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .padding()
                            .background(Color.black.opacity(0.8))
                            .cornerRadius(12)
                            .padding(.bottom, 50)
                            .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .animation(.spring(), value: showToast)
                )
                .alert("You must login to access this feature", isPresented: $showGuestAlert) {
                    Button("Login") {
                        navigator.goTo(.login, replaceLast: true)
                    }
                    Button("Continue as Guest", role: .cancel) {
                    }
                }
            }
    }


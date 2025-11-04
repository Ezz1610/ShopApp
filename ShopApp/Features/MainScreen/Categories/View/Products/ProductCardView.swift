//
//  ProductCardView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 26/10/2025.
//
import SwiftUI

struct ProductCardView: View {
    var product: ProductModel
    @ObservedObject var viewModel: CategoriesProductsViewModel
    @EnvironmentObject var cartManager: CartManager

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // MARK: - Product Image + Favorite Button
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
                
                // Favorite Button
                Button {
                    if let safeProduct = viewModel.products.first(where: { $0.id == product.id }) {
                        viewModel.toggleFavorite(safeProduct)
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
                .padding(8)
                .animation(.easeInOut(duration: 0.2), value: viewModel.favorites)
            }
            
            // MARK: - Title + Price
            VStack(alignment: .leading, spacing: 4) {
                Text(product.title)
                    .font(.system(size: 13, weight: .semibold, design: .rounded))
                    .foregroundColor(.primary)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxHeight: 38, alignment: .top)
                
                Text(lowestPrice(product))
                    .font(.system(size: 13, weight: .regular, design: .rounded))
                    .foregroundColor(.secondary)
            }
            
            // MARK: - Add to Cart Button
            Button {
                cartManager.addToCart(product: product)
                print("Added to cart: \(product.title)")
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
        // Alert for Add to Cart
        .alert("Added to cart", isPresented: $cartManager.addToCartAlert) {
            Button("OK") {}
        } message: {
            Text("You have added \(product.title) to your cart.")
        }
    }
    
    // MARK: - Helper
    private func lowestPrice(_ product: ProductModel) -> String {
        return String(format: "$%.2f", product.validPrice)
    }
}

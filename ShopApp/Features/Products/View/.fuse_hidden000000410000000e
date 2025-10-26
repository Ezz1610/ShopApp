//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 23/10/2025.
//

import Foundation
import SwiftUI

struct ProductsView: View {
    @StateObject private var viewModel = ProductsViewModel()
    
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            
            HStack {
                Text("Products")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // MARK: Search Bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                TextField("Search products...", text: $viewModel.searchText)
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
            }
            .padding(10)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
            .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 2)
            
            // MARK: Product Grid
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .multilineTextAlignment(.center)
                        .padding()
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 16) {
                            ForEach(viewModel.filteredProducts) { product in
                                ProductItemView(product: product)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }
                    .refreshable {
                        await viewModel.fetchProducts()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.fetchProducts()
        }
        .background(Color(.systemGroupedBackground))
    }
}

// MARK: - Product Card with Bottom Right Favorite Button
struct ProductItemView: View {
    let product: ProductModel
    @State private var isPressed = false
    @State private var isFavorite = false
    
    private var priceText: String {
        product.variants.first?.price ?? "-"
    }
    
    private var oldPriceText: String? {
        let oldPrice = product.variants.first?.compareAtPrice ?? ""
        return oldPrice.isEmpty ? nil : oldPrice
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                // MARK: Product Image
                CustomNetworkImage(
                    url: product.image?.src,
                    width: 160,
                    height: 160,
                    cornerRadius: 12
                )
                .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                
                // MARK: Product Info
                VStack(spacing: 6) {
                    Text(product.title)
                        .font(.system(size: 14, weight: .semibold))
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 6) {
                        Text("$\(priceText)")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.accentColor)
                        
                        if let oldPrice = oldPriceText {
                            Text("$\(oldPrice)")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .strikethrough()
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
            .padding(10)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.08), radius: 6, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.97 : 1)
            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressed)
            .onTapGesture {
                withAnimation {
                    isPressed.toggle()
                }
            }
            
            // MARK: Favorite Button (Bottom Right)
            Button(action: {
                withAnimation(.easeInOut) {
                    isFavorite.toggle()
                }
            }) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .font(.system(size: 18))
                    .foregroundColor(isFavorite ? .red : .gray)
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(Circle())
                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 2)
            }
            .padding(8)
        }
    }
}

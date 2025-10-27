//
//  Catogries .swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 24/10/2025.
//

import SwiftUI
import SwiftUI

struct CategoriesView: View {
    @StateObject private var categoriesVM = CategoriesViewModel()
    @StateObject private var productsVM = InlineCategoryProductsViewModel()

    @State private var selectedCategory: Category?

    private let gridCols = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {

                    HomeHeaderView()
                        .padding(.top, 8)
                        .background(Color(.systemBackground))

                    VStack(alignment: .leading, spacing: 16) {

                        Text("Categories")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(categoriesVM.categories) { cat in
                                    CategoryChip(
                                        category: cat,
                                        isSelected: cat.id == selectedCategory?.id,
                                        onTap: {
                                            selectedCategory = cat
                                            productsVM.loadProducts(for: cat)
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 4)
                        }

                        if let heroURL = selectedCategory?.image?.src {
                            AsyncImage(url: URL(string: heroURL)) { phase in
                                switch phase {
                                case .empty:
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.15))
                                case .success(let img):
                                    img
                                        .resizable()
                                        .scaledToFill()
                                case .failure:
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.15))
                                        .overlay(
                                            Image(systemName: "photo")
                                                .font(.title3)
                                                .foregroundColor(.gray)
                                        )
                                @unknown default:
                                    EmptyView()
                                }
                            }
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.horizontal, 16)
                        }

                        Group {
                            if productsVM.isLoading && productsVM.products.isEmpty {
                                ProgressView("Loading products…")
                                    .padding(.horizontal, 16)

                            } else if let err = productsVM.errorMessage, productsVM.products.isEmpty {
                                Text("Error: \(err)")
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 16)

                            } else if productsVM.products.isEmpty {
                                Text("No products available.")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 16)

                            } else {
                                LazyVGrid(
                                    columns: gridCols,
                                    alignment: .leading,
                                    spacing: 16
                                ) {
                                    ForEach(productsVM.products) { product in
                                        ProductCardView(product: product)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 32)
                            }
                        }
                    }
                }
                .background(Color(.systemGray6))
            }
            .background(Color(.systemGray6))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(.hidden, for: .navigationBar) 
            .onAppear {
                if categoriesVM.categories.isEmpty {
                    categoriesVM.loadCategories()
                }
            }
            .onChange(of: categoriesVM.categories.count) { _ in
                if selectedCategory == nil,
                   let first = categoriesVM.categories.first {
                    selectedCategory = first
                    productsVM.loadProducts(for: first)
                }
            }
        }
    }
}

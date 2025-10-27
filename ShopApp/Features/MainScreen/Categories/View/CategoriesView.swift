//
//  Catogries .swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 24/10/2025.
//
import Foundation
import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct CategoriesView: View {
    @EnvironmentObject var navigator: AppNavigator
    @Environment(\.modelContext) private var context
    @State private var searchText = ""

    @StateObject private var categoriesVM: CategoriesProductsViewModel
    @State private var selectedCategory: Category?

    private let gridCols = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(context: ModelContext) {
        _categoriesVM = StateObject(wrappedValue: CategoriesProductsViewModel(context: context))
    }

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

                        // Use HomeSearchBar here
                        HomeSearchBar(searchText: $searchText)

                        // MARK: - Categories Horizontal Scroll
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(categoriesVM.categories) { cat in
                                    CategoryChip(
                                        category: cat,
                                        isSelected: cat.id == selectedCategory?.id,
                                        onTap: {
                                            selectedCategory = cat
                                            Task {
                                                await categoriesVM.loadProducts(for: cat)
                                            }
                                        }
                                    )
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.bottom, 4)
                        }

                        // MARK: - Category Hero Image
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

                        // MARK: - Products Grid / States
                        VStack {
                            if categoriesVM.isLoading && categoriesVM.products.isEmpty {
                                ProgressView("Loading products…")
                                    .padding(.horizontal, 16)

                            } else if let err = categoriesVM.errorMessage, categoriesVM.products.isEmpty {
                                Text("Error: \(err)")
                                    .foregroundColor(.red)
                                    .padding(.horizontal, 16)

                            } else if filteredProducts.isEmpty {
                                Text("No products match your search.")
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal, 16)

                            } else {
                                LazyVGrid(
                                    columns: gridCols,
                                    alignment: .leading,
                                    spacing: 16
                                ) {
                                    ForEach(filteredProducts) { product in
                                        ProductCardView(product: product, viewModel: categoriesVM)
                                            .frame(maxWidth: .infinity)
                                            .onTapGesture {
                                                navigator.goTo(.productDetails(product))
                                            }
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
                Task {
                    if categoriesVM.categories.isEmpty {
                        await categoriesVM.loadCategories()
                    }
                }
            }
            .onChange(of: categoriesVM.categories.count) { _ in
                if selectedCategory == nil,
                   let first = categoriesVM.categories.first {
                    selectedCategory = first
                    Task {
                        await categoriesVM.loadProducts(for: first)
                    }
                }
            }
        }
    }

    // MARK: - Filtered Products
    private var filteredProducts: [ProductModel] {
        if searchText.isEmpty {
            return categoriesVM.products
        } else {
            return categoriesVM.products.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

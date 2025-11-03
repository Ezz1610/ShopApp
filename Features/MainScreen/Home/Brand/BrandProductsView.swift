//
//  HomeHeaderSection.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//

import SwiftUI

import SwiftUI

struct BrandProductsView: View {
    let vendor: String
    @ObservedObject var viewModel: CategoriesProductsViewModel
    @State private var searchText = ""
    @EnvironmentObject var navigator: AppNavigator

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(vendor: String, viewModel: CategoriesProductsViewModel) {
        self.vendor = vendor
        self.viewModel = viewModel
    }

    var body: some View {
        VStack(spacing: 0) {

            // Use HomeSearchBar here
            HomeSearchBar(searchText: $searchText)

            // MARK: - Product Grid / Empty State
            ScrollView {
                if filteredProducts.isEmpty && !viewModel.isLoading {
                    VStack(spacing: 12) {
                        Image(systemName: "shippingbox")
                            .font(.largeTitle)
                            .foregroundColor(.gray)

                        Text("No products found for \(vendor)")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredProducts) { product in
                            ProductCardView(product: product, viewModel: viewModel)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    navigator.goTo(.productDetails(product))
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .background(Color(.systemGray6))
        .navigationTitle(vendor)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .task {
            await viewModel.loadProducts()
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.1))
            }
        }
    }

    // MARK: - Filtered Products
    private var filteredProducts: [ProductModel] {
        if searchText.isEmpty {
            return viewModel.products
        } else {
            return viewModel.products.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

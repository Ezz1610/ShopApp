//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 23/10/2025.
//

import Foundation
import SwiftUI
import SwiftData



struct ProductsView: View {
    @EnvironmentObject var navigator: AppNavigator
    @StateObject private var viewModel: ProductsViewModel

    @State private var searchText = ""
    @State private var selectedProduct: ProductModel?

    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: ProductsViewModel(context: context))
    }

    var body: some View {
        VStack(spacing: 18) {
            header
            searchBar
            productGrid
        }
        .background(Color(.systemGroupedBackground))
        .task { await viewModel.fetchProducts() }
        .navigationBarBackButtonHidden(true)
    }

    private var header: some View {
        HStack {
            Button(action: { navigator.goBack() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 2) {
                Text("Products")
                    .font(.system(size: 26, weight: .bold))
                Text("\(filteredProducts.count) items")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
            }
            .padding(.leading, 6)

            Spacer()

            Button(action: { navigator.goTo(.favoritesView) }) {
                Image(systemName: "heart.fill")
                    .foregroundColor(.red)
                    .padding(8)
                    .background(Color(.secondarySystemBackground))
                    .clipShape(Circle())
            }
        }
        .padding(.horizontal)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search products...", text: $searchText)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
        }
        .padding(12)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .padding(.horizontal)
    }

    private var productGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 18) {
                ForEach(filteredProducts) { product in
                    ProductItemView(
                        product: product,
                        isFavorite: viewModel.isFavorite(product: product),
                        onToggleFavorite: { viewModel.toggleFavorite(product: product) },
                        onTap: { navigator.goTo(.productDetails(product)) }
                    )
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }

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

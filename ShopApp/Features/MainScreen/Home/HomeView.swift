//
//  HomeView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.

import SwiftUI
import SwiftData

struct HomeView: View {
    @Environment(\.modelContext) private var context

    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var categoriesVM: CategoriesProductsViewModel

    @State private var searchText: String = ""

    init(context: ModelContext) {
        CategoriesProductsViewModel.initializeSingleton(context: context)
        _categoriesVM = StateObject(wrappedValue: CategoriesProductsViewModel.shared!)
    }

    private let productColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    // MARK: - Header
                    HomeHeaderView()
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 20) {
                        // MARK: - Search Bar
                        HomeSearchBar(searchText: $searchText)
                            .onChange(of: searchText) { newValue in
                                categoriesVM.searchText = newValue
                            }
                        CouponsView()
                            .frame(height: 250)
                        // MARK: - Dynamic Content (Search / Brands)
                        if !searchText.isEmpty {
                            // ✅ عرض المنتجات لو في بحث
                            SearchResultsView(
                                searchText: $searchText,
                                viewModel: categoriesVM
                            )
                        } else {
                            // ✅ عرض البراندات لو مفيش بحث
                            Group {
                                if homeVM.isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity, alignment: .center)
                                        .padding()
                                } else if let error = homeVM.errorMessage {
                                    Text(error)
                                        .foregroundColor(.red)
                                        .padding()
                                } else {
                                    BrandCollectionView(
                                        brands: homeVM.brands,
                                        viewModel: categoriesVM
                                    )
                                }
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationBarHidden(true)
            .task {
                await homeVM.loadBrands()
                await categoriesVM.loadProducts() // 🟢 نضمن المنتجات متاحة وقت البحث
            }
        }
    }
}

import SwiftUI

struct SearchResultsView: View {
    @Binding var searchText: String
    @ObservedObject var viewModel: CategoriesProductsViewModel
    @EnvironmentObject var navigator: AppNavigator

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if filteredProducts.isEmpty && !viewModel.isLoading {
                VStack(spacing: 12) {
                    Image(systemName: "magnifyingglass")
                        .font(.largeTitle)
                        .foregroundColor(.gray)

                    Text("مفيش نتائج بحث لـ \"\(searchText)\"")
                        .foregroundColor(.gray)
                        .font(.system(size: 14, weight: .medium, design: .rounded))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 60)
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(filteredProducts) { product in
                        ProductCardView(product: product, viewModel: viewModel)
                            .onTapGesture {
                                navigator.goTo(.productDetails(product))
                            }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
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

    private var filteredProducts: [ProductModel] {
        if searchText.isEmpty {
            return []
        } else {
            return viewModel.products.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.vendor.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

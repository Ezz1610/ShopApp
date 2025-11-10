//
//  HomeView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//
//  HomeView.swift
//  ShopApp
//



import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var homeVM: HomeViewModel
    @EnvironmentObject var navigator: AppNavigator

    private let productColumns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    init(context: ModelContext) {
        HomeViewModel.initializeSingleton(context: context)
        _homeVM = StateObject(wrappedValue: HomeViewModel.shared!)
    }

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    HomeHeaderView()
                        .padding(.top, 8)

                    VStack(alignment: .leading, spacing: 20) {
                        // Search bar
                        HomeSearchBar(searchText: $homeVM.searchText)
                        ZStack {
                                                  RoundedRectangle(cornerRadius: 16, style: .continuous)
                                                      .fill(Color.white)
                                                      .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 4)

                                                  CouponsView()
                                                      .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                                              }
                                              .frame(height: 250)
                                              .padding(.horizontal, 16)
                        // MARK: - Dynamic Content
                        VStack {
                            if !homeVM.searchText.isEmpty {
                                // Search results
                                SearchResultsView(
                                    searchText: $homeVM.searchText,
                                    categoriesVM: homeVM
                                )
                            } else {
                                // Loading state
                                if homeVM.isLoading {
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                } else if let error = homeVM.errorMessage {
                                    Text(error)
                                        .foregroundColor(.red)
                                        .padding()
                                } else {
                                    VStack(spacing: 16) {

                                        // MARK: - Brands / Collections
                                        if !homeVM.brands.isEmpty {
                                

                                            BrandCollectionView(
                                                brands: homeVM.brands,
                                                homeVM: homeVM
                                            )
                                            .padding(.horizontal, 16)

                                     
                                        }

                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 24)
                }
            }
            .navigationBarHidden(true)
            .task {
                // Load Brands and optionally vendor products
                await homeVM.loadBrands()
//                await homeVM.loadAllProducts() // Optional, load all products if needed
//                await homeVM.loadProducts(forVendor: "VendorName") // Optional
            }
        }
    }
}


struct SearchResultsView: View {
    @Binding var searchText: String
    @ObservedObject var categoriesVM: HomeViewModel
    @EnvironmentObject var navigator: AppNavigator

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if filteredProducts.isEmpty && !categoriesVM.isLoading {
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
                        ProductCardView(
                            product: product,
                            viewModel: categoriesVM
                        )
                        .onTapGesture {
                            navigator.goTo(.productDetails(product), replaceLast: false)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                .padding(.bottom, 32)
            }
        }
        .overlay {
            if categoriesVM.isLoading {
                ProgressView()
                    .scaleEffect(1.3)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.1))
            }
        }
    }

    private var filteredProducts: [ProductModel] {
        guard !searchText.isEmpty else { return [] }

        return categoriesVM.products.filter { product in
            product.title.localizedCaseInsensitiveContains(searchText) ||
            product.vendor.localizedCaseInsensitiveContains(searchText) ||
            product.tags.localizedCaseInsensitiveContains(searchText)
        }
    }
}

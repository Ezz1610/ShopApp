//
//  HomeHeaderSection.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//

import SwiftUI



struct BrandProductsView: View {
    let brand: SmartCollection
    @ObservedObject var homeVM: HomeViewModel
    @EnvironmentObject var navigator: AppNavigator
    @State private var searchText = ""

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(spacing: 0) {
            HomeSearchBar(searchText: $searchText)

            ScrollView {
                if homeVM.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 100)
                } else if let error = homeVM.errorMessage {
                    VStack(spacing: 10) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                        Text(error)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.top, 100)
                } else if filteredProducts.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "shippingbox")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                        Text("No products found for \(brand.title)")
                            .foregroundColor(.gray)
                            .font(.system(size: 14, weight: .medium, design: .rounded))
                    }
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity)
                } else {
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(filteredProducts) { product in
                            ZStack(alignment: .topTrailing) {
                                // 🟢 كارت المنتج
                                ProductCardView(
                                    product: product,
                                    viewModel: HomeViewModel.shared
                                )
                                .onTapGesture {
                                    navigator.goTo(.productDetails(product))
                                }
//
//                                // ❤️ زرار المفضلة فوق الكارت
//                                Button {
//                                    homeVM.toggleBrandProductFavorite(product)
//                                } label: {
//                                    Image(systemName: homeVM.isBrandProductFavorite(product) ? "heart.fill" : "heart")
//                                        .foregroundColor(.red)
//                                        .padding(8)
//                                        .background(Color.white.opacity(0.8))
//                                        .clipShape(Circle())
//                                        .shadow(radius: 2)
//                                }
//                                .padding(8)
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationTitle(brand.title)
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadProducts()
        }
        .refreshable {
            await loadProducts()
        }
    }

    // MARK: - Load Products
    private func loadProducts() async {
        await homeVM.loadProductsByCollectionTitle(brand)
    }

    // MARK: - Filtered Products
    private var filteredProducts: [ProductModel] {
        if searchText.isEmpty {
            return homeVM.collectionProducts
        } else {
            return homeVM.collectionProducts.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

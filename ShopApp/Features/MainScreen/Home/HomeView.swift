//
//  HomeView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.


import SwiftUI
import SwiftData

import SwiftUI
import SwiftData

struct HomeView: View {
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var categoriesVM: CategoriesProductsViewModel

    @State private var searchText: String = ""

    init(context: ModelContext) {
        _categoriesVM = StateObject(wrappedValue: CategoriesProductsViewModel(context: context))
    }

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

                        // MARK: - Coupons
                        ZStack {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .fill(Color.white)
                                .shadow(color: Color.black.opacity(0.07), radius: 8, x: 0, y: 4)

                            CouponsView()
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        }
                        .frame(height: 250)
                        .padding(.horizontal, 16)

                        // MARK: - Brands
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
                                viewModel: categoriesVM // ✅ shared VM
                            )
                        }
                    }
                    .padding(.bottom, 24)
                }
                .background(Color(.systemGray6))
            }
            .background(Color(.systemGray6))
            .navigationBarHidden(true)
            .task {
                await homeVM.loadBrands()
            }
        }
    }
}

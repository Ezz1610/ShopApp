//
//  ProductsView.swift
//  ShopApp
//
//  Created by mohamed ezz on 23/10/2025.
//

import Foundation
import SwiftUI
import SwiftData
struct ProductsView: View {
    @StateObject private var viewModel: CategoriesProductsViewModel
    @EnvironmentObject var navigator: AppNavigator
    @Environment(\.modelContext) private var context
    @State private var searchText = ""
    // MARK: - Init
    init(context: ModelContext) {
        CategoriesProductsViewModel.initializeSingleton(context: context)
        _viewModel = StateObject(wrappedValue: CategoriesProductsViewModel.shared)
    }

    // MARK: - Grid Layout
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack(spacing: 16) {
            // MARK: Title
            HStack {
                Text("Products")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding(.horizontal)
            .padding(.top, 8)
            
            // MARK: Search Bar
            HomeSearchBar(searchText: $searchText)
                .padding(.top, 4.h)

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
                                ProductCardView(product: product, viewModel: viewModel)
                                    .frame(maxWidth: .infinity)
                                    .onTapGesture {
                                        navigator.goTo(.productDetails(product))
                                    }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 12)
                    }
                    .refreshable {
                        await viewModel.refreshData()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .task {
            await viewModel.refreshData()
        }
        .background(Color(.systemGroupedBackground))
    }
}

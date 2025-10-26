//
//  CategoryProductsPage.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 26/10/2025.
//

import SwiftUI


struct CategoryProductsPage: View {
    @StateObject private var viewModel: CategoryProductsViewModel

    init(category: Category) {
        _viewModel = StateObject(wrappedValue: CategoryProductsViewModel(category: category))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {

                if let heroURL = viewModel.category.image?.src {
                    AsyncImage(url: URL(string: heroURL)) { phase in
                        switch phase {
                        case .empty:
                            Rectangle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        case .success(let img):
                            img.resizable()
                                .scaledToFill()
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                                .clipped()
                        case .failure:
                            Rectangle()
                                .fill(Color.gray.opacity(0.15))
                                .frame(height: 180)
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding(.horizontal, 16)
                }

                if viewModel.isLoading {
                    ProgressView("جارٍ التحميل…")
                        .padding(.horizontal, 16)
                } else if let error = viewModel.errorMessage {
                    Text("حصل خطأ: \(error)")
                        .foregroundColor(.red)
                        .padding(.horizontal, 16)
                } else if viewModel.products.isEmpty {
                    Text("لا توجد منتجات حالياً.")
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 16)
                } else {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 16
                    ) {
                        ForEach(viewModel.products) { product in
                            ProductCardView(product: product)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .padding(.vertical, 16)
        }
        .navigationTitle(viewModel.category.title)
        .onAppear {
            viewModel.loadProducts()
        }
    }
}



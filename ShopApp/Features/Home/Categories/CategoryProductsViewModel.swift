//
//  CategoryProductsViewModel.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 26/10/2025.
//
import Foundation

@MainActor
final class CategoryProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    let category: Category

    init(category: Category) {
        self.category = category
    }

    func loadProducts() {
        if !products.isEmpty { return }

        isLoading = true
        errorMessage = nil

        Task {
            do {
                let list: [Product]

                if category.id == -1 {
                    list = try await HomeApiService.shared.fetchAllProducts(limit: 250)
                } else {
                    list = try await HomeApiService.shared.fetchProducts(for: category.id)
                }

                self.products = list
                self.isLoading = false
            } catch {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}

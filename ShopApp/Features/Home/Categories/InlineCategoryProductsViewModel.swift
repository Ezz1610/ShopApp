//
//  InlineCategoryProductsViewModel.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 26/10/2025.
//
import Foundation
import SwiftUI

@MainActor
final class InlineCategoryProductsViewModel: ObservableObject {
    @Published var products: [Product] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func loadProducts(for category: Category) {
        if isLoading { return }

        isLoading = true
        errorMessage = nil
        products = []

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

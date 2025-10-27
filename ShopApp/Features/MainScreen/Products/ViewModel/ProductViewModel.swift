//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 23/10/2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class ProductViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let apiService = ApiServiceProducts()

    var filteredProducts: [ProductModel] {
        if searchText.isEmpty {
            return products
        } else {
            return products.filter {
                $0.title.localizedCaseInsensitiveContains(searchText) ||
                $0.vendor.localizedCaseInsensitiveContains(searchText) ||
                $0.tags.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    func fetchProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            products = try await apiService.fetchProducts()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

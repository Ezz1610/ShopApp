//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 02/11/2025.
//

import Foundation
import Foundation
import SwiftUI

@MainActor
class BaseProductsViewModel: ObservableObject {
    @Published var products: [ProductModel] = []
    @Published var searchText: String = ""
    @Published var isLoading = false
    @Published var errorMessage: String?

    let api = ApiServices()

    // MARK: - Fetching (to be overridden if needed)
    func fetchProducts() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            products = try await api.fetchAllProducts(limit: 250)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Search filter (base)
    var filteredProducts: [ProductModel] {
        if searchText.isEmpty { return products }
        return products.filter {
            $0.title.localizedCaseInsensitiveContains(searchText)
            || $0.vendor.localizedCaseInsensitiveContains(searchText)
            || $0.tags.localizedCaseInsensitiveContains(searchText)
        }
    }
}

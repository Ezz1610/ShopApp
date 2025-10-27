//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 27/10/2025.
//

import Foundation
import SwiftUI
import SwiftData
@MainActor
final class CategoriesProductsViewModel: ObservableObject {

    // MARK: - Published
    @Published var categories: [Category] = []
    @Published var products: [ProductModel] = []
    @Published var searchText = ""
    @Published var selectedCategory: Category?
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Dependencies
    private let api = ApiServices()
    private let dataHelper: SwiftDataHelper

    // MARK: - Optional Vendor
    let vendor: String?

    // MARK: - Init
    init(context: ModelContext, vendor: String? = nil) {
        self.dataHelper = SwiftDataHelper(context: context)
        self.vendor = vendor

        Task {
            if let vendor = vendor {
                await loadProducts(forVendor: vendor)
            } else {
                await loadCategories()
            }
        }
    }

    // MARK: - Filtered Products
    var filteredProducts: [ProductModel] {
        if searchText.isEmpty { return products }
        return products.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    // MARK: - Load Categories
    func loadCategories() async {
        guard categories.isEmpty else { return }
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            let data = try await api.fetchCategories()
            let cleaned = data.filter { $0.image?.src != nil }
            let priority = ["MEN", "WOMEN", "KID", "SALE"]
            let sorted = cleaned.sorted { a, b in
                (priority.firstIndex(of: a.title.uppercased()) ?? 999) <
                (priority.firstIndex(of: b.title.uppercased()) ?? 999)
            }
            let all = Category(id: -1, title: "All", image: nil)
            categories = [all] + sorted
            selectedCategory = all
            await loadProducts(for: all)
        } catch {
            errorMessage = error.localizedDescription
            products = []
        }
    }

    // MARK: - Load Products by Category
    func loadProducts(for category: Category? = nil) async {
        let cat = category ?? selectedCategory
        guard let cat else { return }

        selectedCategory = cat
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            if cat.id == -1 {
                products = try await api.fetchAllProducts(limit: 250)
            } else {
                products = try await api.fetchProducts(for: cat.id)
            }
        } catch {
            errorMessage = error.localizedDescription
            products = []
        }
    }

    // MARK: - Load Products by Vendor
    func loadProducts(forVendor vendor: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            products = try await api.fetchProducts(byVendor: vendor)
        } catch {
            errorMessage = error.localizedDescription
            products = []
        }
    }

    // MARK: - Favorites
    func isFavorite(product: ProductModel) -> Bool {
        dataHelper.isFavorite(product.id)
    }

    func toggleFavorite(product: ProductModel) {
        dataHelper.toggleFavorite(product: product)
        objectWillChange.send()
    }
}

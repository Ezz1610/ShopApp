//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 27/10/2025.
//

//
//  CategoriesProductsViewModel.swift
//  ShopApp
//
//  Created by mohamed ezz on 27/10/2025.
//

import Foundation
import SwiftUI
import SwiftData

// MARK: - Product Filter Model
struct ProductFilter {
    var productTypes: Set<String> = []
    var vendor: String? = nil
    var optionSelections: [String: String] = [:]
    var maxPrice: Double? = nil
    var onlyInStock: Bool = false
    var onlyAccessories: Bool = false
}

// MARK: - ViewModel
@MainActor
final class CategoriesProductsViewModel: ObservableObject {

    // MARK: - Published (UI Binding)
    @Published var categories: [Category] = []
    @Published var products: [ProductModel] = []
    @Published var favorites: [ProductModel] = []
    @Published var searchText: String = ""
    @Published var selectedCategory: Category?
    @Published var filter = ProductFilter()
    @Published var isLoading = false
    @Published var errorMessage: String?

    // MARK: - Dependencies
    private let api = ApiServices()
    private let dataHelper: SwiftDataHelper
    private let vendor: String?

    // MARK: - Init
    init(context: ModelContext, vendor: String? = nil) {
        self.dataHelper = SwiftDataHelper(context: context)
        self.vendor = vendor

        Task { await initializeData() }
    }

    private func initializeData() async {
        if let vendor = vendor {
            await loadProducts(forVendor: vendor)
        } else {
            await loadCategories()
        }
        await refreshFavorites()
    }

    // MARK: - Type Groups
    private let typeGroups: [String: [String]] = [
        "shoes": ["SHOES"],
        "accessories": ["ACCESSORIES"]
    ]

    func currentChosenGroups() -> Set<String> {
        typeGroups.compactMap { (key, values) in
            values.contains { filter.productTypes.contains($0) } ? key : nil
        }.reduce(into: Set<String>()) { $0.insert($1) }
    }

    func applyGroups(_ groups: Set<String>) {
        filter.productTypes = groups
            .compactMap { typeGroups[$0] }
            .reduce(into: Set<String>()) { $0.formUnion($1) }
    }

    // MARK: - Filtered Products
    var filteredProducts: [ProductModel] {
        products.filter { product in
            // Product type filter
            if !filter.productTypes.isEmpty {
                let type = product.productType.trimmingCharacters(in: .whitespacesAndNewlines)
                if !filter.productTypes.contains(where: { $0.caseInsensitiveCompare(type) == .orderedSame }) {
                    return false
                }
            }

            // Accessories filter
            if filter.onlyAccessories {
                let isAccessory = product.productType.lowercased().contains("accessor")
                    || product.tags.lowercased().contains("accessor")
                if !isAccessory { return false }
            }

            // Vendor filter
            if let wantedVendor = filter.vendor,
               !wantedVendor.isEmpty,
               product.vendor.caseInsensitiveCompare(wantedVendor) != .orderedSame {
                return false
            }

            // Max price filter
            if let limit = filter.maxPrice {
                let prices = product.variants.compactMap { Double($0.price) }
                if let minPrice = prices.min(), minPrice > limit { return false }
            }

            // Stock filter
            if filter.onlyInStock,
               !product.variants.contains(where: { $0.inventoryQuantity > 0 }) {
                return false
            }

            // Options filter
            for (optionName, chosenValue) in filter.optionSelections {
                guard let option = product.options.first(where: { $0.name == optionName }) else {
                    return false
                }
                if !option.values.contains(where: { $0.caseInsensitiveCompare(chosenValue) == .orderedSame }) {
                    return false
                }
            }

            // Search filter
            if !searchText.isEmpty {
                let keyword = searchText.lowercased()
                if !(product.title.lowercased().contains(keyword)
                     || product.vendor.lowercased().contains(keyword)
                     || product.tags.lowercased().contains(keyword)) {
                    return false
                }
            }

            return true
        }
    }

    // MARK: - Load Categories
    func loadCategories() async {
        guard categories.isEmpty else { return }

        isLoading = true; errorMessage = nil
        defer { isLoading = false }

        do {
            let fetched = try await api.fetchCategories()
            let valid = fetched.filter { $0.image?.src != nil }

            let priority = ["MEN", "WOMEN", "KID", "SALE"]
            let sorted = valid.sorted {
                (priority.firstIndex(of: $0.title.uppercased()) ?? 999) <
                (priority.firstIndex(of: $1.title.uppercased()) ?? 999)
            }

            let allCategory = Category(id: -1, title: "All", image: nil)
            categories = [allCategory] + sorted
            selectedCategory = allCategory

            await loadProducts(for: allCategory)
        } catch {
            errorMessage = "⚠️ Failed to load categories: \(error.localizedDescription)"
            products = []
        }
    }

    // MARK: - Load Products
    func loadProducts(for category: Category? = nil) async {
        let cat = category ?? selectedCategory
        guard let cat else { return }

        selectedCategory = cat
        isLoading = true; errorMessage = nil
        defer { isLoading = false }

        do {
            if cat.id == -1 {
                products = try await api.fetchAllProducts(limit: 250)
            } else {
                products = try await api.fetchProducts(for: cat.id)
            }
        } catch {
            errorMessage = "⚠️ Failed to load products: \(error.localizedDescription)"
            products = []
        }
    }

    func loadProducts(forVendor vendor: String) async {
        isLoading = true; errorMessage = nil
        defer { isLoading = false }

        do {
            products = try await api.fetchProducts(byVendor: vendor)
        } catch {
            errorMessage = "⚠️ Failed to load vendor products: \(error.localizedDescription)"
            products = []
        }
    }

    // MARK: - Refresh
    func refreshData() async {
        if let vendor = vendor {
            await loadProducts(forVendor: vendor)
        } else if let category = selectedCategory {
            await loadProducts(for: category)
        } else {
            await loadCategories()
        }
        await refreshFavorites()
    }

    // MARK: - Favorites
    func isFavorite(_ product: ProductModel) -> Bool {
        dataHelper.isFavorite(product.id)
    }

    func toggleFavorite(_ product: ProductModel) {
        dataHelper.toggleFavorite(product: product)
        Task { await refreshFavorites() }
    }

    func refreshFavorites() async {
        favorites = dataHelper.fetchAllFavorites()
    }

    func removeFavorite(id: Int) {
        dataHelper.removeFavorite(id: id)
        favorites.removeAll { $0.id == id }
    }
}

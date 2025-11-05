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
//FIRST

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
    @Published var filteredProducts: [ProductModel] = []
    @Published var allProducts: [ProductModel] = []
    @Published var allProductTypes: [String] = ["All"]

    // MARK: - Dependencies
    private let api = ApiServices.shared
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

    // MARK: - Filtering Helpers
    func filterProducts(by subCategory: String) {
        guard !products.isEmpty else {
            print("No products to filter")
            return
        }

        print("Filtering by:", subCategory)
        print("Available product types:", Set(products.compactMap { $0.productType }))

        guard subCategory != "All" else {
            if let selected = selectedCategory {
                filterByCategory(selected)
            } else {
                filteredProducts = allProducts
            }
            return
        }

        let sub = subCategory.lowercased()
        filteredProducts = products.filter { product in
            let type = product.productType.lowercased()
            let title = product.title.lowercased()
            return type.contains(sub) || title.contains(sub)
        }

        print("Filtered count:", filteredProducts.count)
    }

    func loadAllProductTypes() async throws {
        let all = try await api.fetchAllProducts(limit: 250)
        let types = Set(
            all.compactMap { $0.productType.trimmingCharacters(in: .whitespacesAndNewlines) }
                .filter { !$0.isEmpty }
        )
        allProductTypes = ["All"] + types.sorted()
    }

    func loadAllProducts() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let fetched = try await api.fetchAllProducts(limit: 250)
            allProducts = fetched
            products = fetched
            filteredProducts = fetched
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func filterByCategory(_ category: Category) {
        filteredProducts = products.filter { product in
                product.title.localizedCaseInsensitiveContains(category.title)
            }
    }

    // MARK: - Load Categories
    func loadCategories() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let fetched = try await ApiServices.shared.fetchCategories()
            categories = fetched
            self.selectedCategory = fetched.first
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    // MARK: - Load Products
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
            filteredProducts = products
            if let selected = selectedCategory {
                filterByCategory(selected)
            }
        } catch {
            errorMessage = "⚠️ Failed to load products: \(error.localizedDescription)"
            products = []
            filteredProducts = []
        }
    }

    func loadProducts(forVendor vendor: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            products = try await api.fetchProducts(byVendor: vendor)
            filteredProducts = products
        } catch {
            errorMessage = "⚠️ Failed to load vendor products: \(error.localizedDescription)"
            products = []
            filteredProducts = []
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

//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 27/10/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct ProductFilter {
    var productTypes: Set<String> = []
    var vendor: String? = nil
    var optionSelections: [String: String] = [:]
    var maxPrice: Double? = nil
    var onlyInStock: Bool = false
    var onlyAccessories: Bool = false
}

@MainActor
final class CategoriesProductsViewModel: ObservableObject {

    // MARK: - Published (UI state)
    @Published var categories: [Category] = []
    @Published var products: [ProductModel] = []
    @Published var searchText = ""
    @Published var selectedCategory: Category?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var filter = ProductFilter()

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

   
    let typeGroups: [String: [String]] = [
        "shoes":        ["SHOES"],
        "accessories":  ["ACCESSORIES"]
    ]

    func currentChosenGroups() -> Set<String> {
        var result: Set<String> = []

        for (groupKey, concreteTypes) in typeGroups {
            let intersects = concreteTypes.contains { t in
                filter.productTypes.contains { sel in
                    sel.caseInsensitiveCompare(t) == .orderedSame
                }
            }
            if intersects {
                result.insert(groupKey)
            }
        }

        return result
    }

   
    func applyGroups(_ groups: Set<String>) {
        var combinedTypes = Set<String>()
        for key in groups {
            if let list = typeGroups[key] {
                for t in list {
                    combinedTypes.insert(t)
                }
            }
        }

        filter.productTypes = combinedTypes
        print("APPLY FILTER TYPES =", filter.productTypes)
    }

    // MARK: - Simple search filter (legacy)
    var filteredProducts: [ProductModel] {
        if searchText.isEmpty { return products }
        return products.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var filteredProductsFinal: [ProductModel] {
        products.filter { product in

            if !filter.productTypes.isEmpty {
                let thisType = product.productType
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                let matchesSelectedType = filter.productTypes.contains { selected in
                    selected.caseInsensitiveCompare(thisType) == .orderedSame
                }

                if !matchesSelectedType {
                    return false
                }
            }

            if filter.onlyAccessories {
                let isAccessoryByType = product.productType
                    .lowercased()
                    .contains("accessor")
                let isAccessoryByTags = product.tags
                    .lowercased()
                    .contains("accessor")
                if !(isAccessoryByType || isAccessoryByTags) {
                    return false
                }
            }

            if let wantedVendor = filter.vendor,
               !wantedVendor.isEmpty,
               product.vendor.caseInsensitiveCompare(wantedVendor) != .orderedSame {
                return false
            }

            // 4. max price filter
            if let limit = filter.maxPrice {
                let prices = product.variants.compactMap { Double($0.price) }
                if let minPrice = prices.min(), minPrice > limit {
                    return false
                }
            }

            // 5. in-stock only filter
            if filter.onlyInStock {
                let hasStock = product.variants.contains { $0.inventoryQuantity > 0 }
                if !hasStock {
                    return false
                }
            }


            for (optionName, chosenValue) in filter.optionSelections {
                guard let option = product.options.first(where: { $0.name == optionName }) else {
                    return false
                }

                let match = option.values.contains {
                    $0.caseInsensitiveCompare(chosenValue) == .orderedSame
                }
                if !match { return false }
            }

            // 7. search text
            if !searchText.isEmpty {
                let matchesTitle = product.title
                    .localizedCaseInsensitiveContains(searchText)
                if !matchesTitle {
                    return false
                }
            }

            return true
        }
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

    // MARK: - Load Products (by category)
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

            print("DEBUG product types =", Set(products.map { $0.productType }))

        } catch {
            errorMessage = error.localizedDescription
            products = []
        }
    }

    // MARK: - Load Products (by vendor)
    func loadProducts(forVendor vendor: String) async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            products = try await api.fetchProducts(byVendor: vendor)

            // Debug again here (optional)
            print("DEBUG product types =", Set(products.map { $0.productType }))

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

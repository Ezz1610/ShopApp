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
        "shoes":       ["SHOES"],
        "accessories": ["ACCESSORIES", "BAGS", "BAG"],
        "tshirts":     ["TSHIRTS", "TSHIRT", "TEES", "T-SHIRTS"]
    ]


    func currentChosenGroups() -> Set<String> {
        typeGroups.compactMap { (key, values) in
            values.contains { filter.productTypes.contains($0) } ? key : nil
        }.reduce(into: Set<String>()) { $0.insert($1) }
    }

    func applyGroups(_ groups: Set<String>) {
        filter.productTypes = groups
            .compactMap { typeGroups[$0] }
            .reduce(into: Set<String>()) { $0.formUnion($1.map { $0.uppercased() }) }
    }

    func applyActiveFilters() {
        var result = products

        // فلترة حسب نوع المنتج (لو المستخدم اختار مجموعات)
        if !filter.productTypes.isEmpty {
            let allowed = filter.productTypes.map { $0.uppercased() }
            result = result.filter { p in
                let t = (p.productType ?? "").uppercased()
                return allowed.contains(where: { t.contains($0) })
            }
        }

        // فلترة البحث
        let q = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if !q.isEmpty {
            result = result.filter { p in
                let title = p.title.lowercased()
                let vendor = (p.vendor ?? "").lowercased()
                let type   = (p.productType ?? "").lowercased()

                // تطبيع الـ tags أياً كان نوعها
                let tagsAsArray: [String] = {
                    if let arr = p.tags as? [String] { return arr }
                    if let str = p.tags as? String { return str.split(separator: ",").map { String($0) } }
                    return []
                }().map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }

                return title.contains(q)
                    || vendor.contains(q)
                    || type.contains(q)
                    || tagsAsArray.contains(where: { $0.contains(q) })
            }
        }

        filteredProducts = result
    }


    // MARK: - Filtering Helpers
    func filterProducts(by subCategory: String) {
        guard !products.isEmpty else { return }
        guard subCategory != "All" else {
            filteredProducts = products
            return
        }

        let sub = subCategory.lowercased()

        filteredProducts = products.filter { p in
            // نوع المنتج (قد يكون Optional)
            let type = (p.productType ?? "").lowercased()

            // طبّيع tags إلى [String] lowercase بمرونة
            let tagsLower: [String] = {
                // لو هي أصلًا [String]
                if let arr = p.tags as? [String] {
                    return arr.map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                }
                // لو جايالك كسلسلة "women, shoes ,SALE"
                if let str = p.tags as? String {
                    return str
                        .split(separator: ",")
                        .map { $0.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
                }
                // لو أي نوع آخر (مثلاً [Any] أو nil)
                return []
            }()

            return type.contains(sub) || tagsLower.contains(sub)
        }
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
        filteredProducts = products
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
    // ViewModel
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
                products = try await api.fetchProducts(for: cat.id) // << التعديل هنا
            }
            // لو عندك فلاتر حقيقية (price/vendor/inStock)، نادِ دالة موحدة:
            // applyActiveFilters()
            filteredProducts = products   // مؤقتًا لو ماعندكش فلاتر
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

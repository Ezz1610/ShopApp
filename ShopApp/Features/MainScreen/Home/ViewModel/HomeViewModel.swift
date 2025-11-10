
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
    var optionSelections: [String: String] = [:]
    var maxPrice: Double? = nil
    var onlyInStock: Bool = false
    var onlyAccessories: Bool = false
}

@MainActor
final class HomeViewModel: ObservableObject {
    private let dataHelper: SwiftDataHelper
    private let apiService = ApiServices()

    // MARK: - Published Properties
    @Published var categories: [Category] = []
    @Published var allProducts: [ProductModel] = [] // كل المنتجات
    @Published var products: [ProductModel] = []    // المنتجات المعروضة حاليًا
    @Published var favorites: [ProductModel] = []

    @Published var selectedCategory: Category?
    @Published var filter = ProductFilter()
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText: String = ""

    // MARK: - Singleton
    static var shared: HomeViewModel!

    // MARK: - Brands / Collections
    @Published var brands: [SmartCollection] = []
    @Published var collectionProducts: [ProductModel] = []

    private init(context: ModelContext) {
        self.dataHelper = SwiftDataHelper.shared(context: context)
    }

    static func initializeSingleton(context: ModelContext) {
        guard shared == nil else { return }
        shared = HomeViewModel(context: context)
    }

    // MARK: - Load Brands / SmartCollections
    func loadBrands() async {
        guard !isLoading else { return }
        isLoading = true
       // errorMessage = nil
        defer { isLoading = false }

        do {
            //let fetchedBrands = try await apiService.fetchSmartCollections()
            if brands.isEmpty {
                let fetchedBrands = try await apiService.fetchSmartCollections()
                brands = fetchedBrands
            }
          
        } catch {
            errorMessage = error.localizedDescription
            print("errorrrrrr 1 \(errorMessage)")
            brands = []
        }
    }

    // MARK: - Load Products by Brand / Collection Title
    func loadProductsByCollectionTitle(_ collection: SmartCollection) async {
        isLoading = true
     //   errorMessage = nil
        defer { isLoading = false }

        do {
            collectionProducts = []
            let products = try await apiService.fetchProducts(byVendor: collection.title)
            collectionProducts = products
            print("✅ Loaded \(products.count) products for collection title \(collection.title)")
        } catch {
            errorMessage = "❌ Failed to load products for collection \(collection.title): \(error.localizedDescription)"
            print("errorrrrrr 2 \(errorMessage)")
            collectionProducts = []
        }
    }
    // MARK: - ADDED (Groups) - تعريف مجموعات الأنواع للأزرار
        /// مفاتيح الشيت -> أنواع المنتج الفعلية (كما تأتي من الـ API)
        private let typeGroups: [String: [String]] = [
            "shoes":       ["SHOES"],
            "accessories": ["ACCESSORIES", "BAGS", "BAG"],
             "tshirts":  ["TSHIRTS", "TSHIRT", "TEES", "T-SHIRTS"]
        ]

        // MARK: - ADDED (Groups) - استخراج المجموعات المختارة حاليًا من الفلتر
        func currentChosenGroups() -> Set<String> {
            var result = Set<String>()
            for (key, values) in typeGroups {
                // إذا كان أي نوع من أنواع هذه المجموعة موجودًا بالفعل في الفلتر
                if values.contains(where: { v in
                    filter.productTypes.contains { $0.caseInsensitiveCompare(v) == .orderedSame }
                }) {
                    result.insert(key)
                }
            }
            return result
        }

        // MARK: - ADDED (Groups) - تطبيق المجموعات القادمة من الشيت على الفلتر
        func applyGroups(_ groups: Set<String>) {
            var mapped = Set<String>()
            for g in groups {
                if let arr = typeGroups[g] {
                    for t in arr {
                        mapped.insert(t.uppercased())
                    }
                }
            }
            filter.productTypes = mapped
            // لا حاجة لاستدعاء شيء إضافي: filteredProducts محسوبة وستتحدث تلقائيًا
        }
    // MARK: - Filtered Products
    var filteredProducts: [ProductModel] {
        products.filter { product in
            if !searchText.isEmpty {
                let keyword = searchText.lowercased()
                guard product.title.lowercased().contains(keyword) ||
                      product.vendor.lowercased().contains(keyword) ||
                      product.tags.lowercased().contains(keyword) else { return false }
            }

            if !filter.productTypes.isEmpty {
                let type = product.productType.trimmingCharacters(in: .whitespacesAndNewlines)
                if !filter.productTypes.contains(where: { $0.caseInsensitiveCompare(type) == .orderedSame }) {
                    return false
                }
            }

            if filter.onlyAccessories {
                let isAccessory = product.productType.lowercased().contains("accessor") ||
                                  product.tags.lowercased().contains("accessor")
                if !isAccessory { return false }
            }

            if let limit = filter.maxPrice {
                let prices = product.variants.compactMap { Double($0.price) }
                if let minPrice = prices.min(), minPrice > limit { return false }
            }

            if filter.onlyInStock, !product.variants.contains(where: { $0.inventoryQuantity > 0 }) {
                return false
            }

            for (optionName, chosenValue) in filter.optionSelections {
                guard let option = product.options.first(where: { $0.name == optionName }) else { return false }
                if !option.values.contains(where: { $0.caseInsensitiveCompare(chosenValue) == .orderedSame }) { return false }
            }

            return true
        }
    }

    // MARK: - Favorites Handling
    func isFavorite(_ product: ProductModel) -> Bool {
        dataHelper.isFavorite(product.id)
    }

    func toggleFavorite(_ product: ProductModel) {
        
        dataHelper.toggleFavorite(product: product)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.favorites = self.dataHelper.fetchAllFavorites().map { $0.copy() }
        }
    }

    func refreshFavorites() async {
        self.favorites = dataHelper.fetchAllFavorites().map { $0.copy() }
    }

    func removeFavorite(id: Int) {
        dataHelper.removeFavorite(id: id)
        favorites.removeAll { $0.id == id }
    }

    // MARK: - NEW: Add Brand Product to Favorites
    func toggleBrandProductFavorite(_ product: ProductModel) {
        dataHelper.toggleFavorite(product: product)
        favorites = dataHelper.fetchAllFavorites().map { $0.copy() }
    }

    func isBrandProductFavorite(_ product: ProductModel) -> Bool {
        return dataHelper.isFavorite(product.id)
    }

    // MARK: - API & Local Filtering
    func loadProducts() async {
        isLoading = true
      //  errorMessage = nil
        do {
            let fetched = try await apiService.fetchAllProducts(limit: 250)
            self.allProducts = fetched
            self.products = fetched
        } catch {
            self.errorMessage = error.localizedDescription
            print("errorrrrrr 3 \(errorMessage)")
        }
        isLoading = false
    }

    func updateProductsForCollection(_ collection: Category) {
        if collection.id == -1 || collection.title.lowercased() == "all" {
            products = allProducts
        } else {
            let normalizedTitle = collection.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
            products = allProducts.filter { $0.tags.lowercased().contains(normalizedTitle) }
        }
    }

    // MARK: - Categories
    func loadCategories() async {
        isLoading = true
      //  errorMessage = nil
        do {
            let fetchedCategories = try await apiService.fetchCategories()

            let allCategory = Category(id: -1, title: "All", image: nil)
            categories = [allCategory] + fetchedCategories
        } catch {
            errorMessage = error.localizedDescription
            print("errorrrrrr 4 \(errorMessage)")
            categories = []
        }
        isLoading = false
    }
}

//
//  ApiServices.swift
//  ShopApp
//
//  Created by mohamed ezz on 24/10/2025.
//
//FIRST

//
//  ApiServices.swift
//  ShopApp
//
//  Created by mohamed ezz on 24/10/2025.
//
//FIRST

import Foundation
final class ApiServices {
    private let baseURL = AppConstant.baseUrl
    private let dataHelper = RemoteDataHelper.shared
    
    func fetchDiscountCodes(for ruleID: Int) async throws -> [DiscountCode] {
        let fullURL = "\(baseURL)/price_rules/\(ruleID)/discount_codes.json"
        let response: DiscountResponse = try await dataHelper.fetchData(from: fullURL)
        return response.discount_codes
    }
 

    func fetchProducts() async throws -> [ProductModel] {
        let fullURL = "\(baseURL)\(ApiUrls.products)"
        let response: ProductsResponse = try await dataHelper.fetchData(from: fullURL)
        return response.products
    }
  

    
    func fetchCategories() async throws -> [Category] {
        let fullURL = "\(baseURL)/custom_collections.json"
        let response: CategoriesResponse = try await dataHelper.fetchData(from: fullURL)
        return response.custom_collections
    }
    func fetchProducts(for collectionID: Int) async throws -> [ProductModel] {
        if collectionID == -1 {
            // For -1 use limit=250 as tests expect
            return try await fetchAllProducts(limit: 250)
        }

        // Step 1: fetch collects for the collection id
        let collectsURL = "\(baseURL)/collects.json?collection_id=\(collectionID)"
        struct CollectsResponse: Decodable { let collects: [Collect] }
        struct Collect: Decodable { let product_id: Int }

        let collectsResponse: CollectsResponse = try await dataHelper.fetchData(from: collectsURL)
        let productIDs = collectsResponse.collects.map { String($0.product_id) }
        guard !productIDs.isEmpty else { return [] }

        // Step 2: fetch products by comma-separated ids
        let idsString = productIDs.joined(separator: ",")
        let productsURL = "\(baseURL)/products.json?ids=\(idsString)"
        let response: ProductsResponse = try await dataHelper.fetchData(from: productsURL)
        return response.products
    }


    func fetchAllProducts(limit: Int = 8) async throws -> [ProductModel] {
        let fullURL = "\(baseURL)/products.json?limit=\(limit)"
        let response: ProductsResponse = try await dataHelper.fetchData(from: fullURL)
        return response.products
    }

    func fetchVendors() async throws -> [String] {
        // get all products (limit 250) then extract unique vendors and sort case-insensitively
        let fullURL = "\(baseURL)/products.json?limit=250"
        let response: ProductsResponse = try await dataHelper.fetchData(from: fullURL)
        let vendorsSet = Set(response.products.compactMap { $0.vendor })
        let sorted = vendorsSet.sorted { $0.localizedCaseInsensitiveCompare($1) == .orderedAscending }
        return sorted
    }

    func fetchProducts(byVendor vendor: String) async throws -> [ProductModel] {
        // fetch all products, then filter by vendor (case-insensitive)
        let fullURL = "\(baseURL)/products.json?limit=250"
        let response: ProductsResponse = try await dataHelper.fetchData(from: fullURL)
        
        let filteredProducts = response.products.filter { product in
            product.vendor.caseInsensitiveCompare(vendor) == .orderedSame
        }
        
        return filteredProducts
    }

    func fetchSmartCollections() async throws -> [SmartCollection] {
        let fullURL = "\(baseURL)/smart_collections.json"
        let response: SmartCollectionResponse = try await dataHelper.fetchData(from: fullURL)
        return response.smart_collections
    }
    
    func fetchProductsByCollectionID(_ collectionID: Int) async throws -> [ProductModel] {
        let fullURL = "\(baseURL)/collections/\(collectionID)/products.json"
        let response: ProductsResponse = try await dataHelper.fetchData(from: fullURL)
        return response.products
    }
}

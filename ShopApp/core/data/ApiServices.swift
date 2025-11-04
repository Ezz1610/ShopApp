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
        print("aaaaaaaa##\(fullURL)")
        let response: DiscountResponse = try await dataHelper.fetchData(from: fullURL)
        return response.discount_codes
    }
 

    func fetchProducts() async throws -> [ProductModel] {
        let fullURL = "\(baseURL)\(ApiUrls.products)"
        let response: ProductsResponse = try await dataHelper.fetchData(from: fullURL)
        print("aaaaaaaa#\(fullURL)")
        print("aaaaaaaa#\(response.products.count)")
        return response.products
    }
    
    func fetchCategories() async throws -> [Category] {
        let fullURL = "\(baseURL)/custom_collections.json"
        let response: CategoriesResponse = try await dataHelper.fetchData(from: fullURL)
        return response.custom_collections
    }

    func fetchProducts(for collectionID: Int) async throws -> [ProductModel] {
        // 1) Fetch collects
        let collectsURL = "\(baseURL)/collects.json?collection_id=\(collectionID)"
        struct CollectsResponse: Decodable { let collects: [Collect] }
        struct Collect: Decodable { let product_id: Int }

        let collectsResponse: CollectsResponse = try await dataHelper.fetchData(from: collectsURL)
        let productIDs = collectsResponse.collects.map { String($0.product_id) }
        guard !productIDs.isEmpty else { return [] }

        // 2) Get products by IDs
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
        let fullURL = "\(baseURL)/products.json?limit=250"
        let response: ProductsResponse = try await dataHelper.fetchData(from: fullURL)
        let vendors = Set(response.products.compactMap { $0.vendor })
        return Array(vendors).sorted()
    }

    func fetchProducts(byVendor vendor: String) async throws -> [ProductModel] {
        let encodedVendor = vendor.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? vendor
        let fullURL = "\(baseURL)/products.json?vendor=\(encodedVendor)"
        let response: ProductsResponse = try await dataHelper.fetchData(from: fullURL)
        return response.products
    }

    func fetchSmartCollections() async throws -> [SmartCollection] {
        let fullURL = "\(baseURL)/smart_collections.json"
        let response: SmartCollectionResponse = try await dataHelper.fetchData(from: fullURL)
        return response.smart_collections
    }

}

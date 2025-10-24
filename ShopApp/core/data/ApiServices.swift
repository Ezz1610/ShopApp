//
//  ApiServices.swift
//  ShopApp
//
//  Created by mohamed ezz on 24/10/2025.
//

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
    

}

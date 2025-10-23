//
//  ApiService.swift
//  ShopApp
//
//  Created by Soha Elgaly on 22/10/2025.
//

import Foundation

final class ApiService {
    private let baseURL = ApiUrls.base
    private let dataHelper = RemoteDataHelper.shared
    func fetchDiscountCodes(for ruleID: Int) async throws -> [DiscountCode] {
        let fullURL = "\(baseURL)/price_rules/\(ruleID)/discount_codes.json"
        let response: Response = try await dataHelper.fetchData(from: fullURL)
        return response.discount_codes
    }
}

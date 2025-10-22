//
//  ApiService.swift
//  ShopApp
//
//  Created by Soha Elgaly on 22/10/2025.
//

import Foundation

final class ApiService {
   private let baseURL = "https://iosr2g2.myshopify.com/admin/api/2025-07"
   private let _t = "SHOPIFY_ACCESS_TOKEN"

    
  private  func makeRequest(path: String) -> URLRequest {
        var request = URLRequest(url: URL(string: "\(baseURL)\(path)")!)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(_t, forHTTPHeaderField: "X-Shopify-Access-Token")
        return request
    }
    
    func fetchDiscountCode(for ruleID: Int) async throws -> [DiscountCode] {
        var request = makeRequest(path: "/price_rules/\(ruleID)/discount_codes.json")
        request.httpMethod = "GET"
        let (data,_) = try await URLSession.shared.data(for: request)
        return try JSONDecoder().decode(Response.self, from: data).discount_codes
    }
    
}

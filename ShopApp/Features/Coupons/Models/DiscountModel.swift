//
//  DiscountModel.swift
//  ShopApp
//
//  Created by Soha Elgaly on 22/10/2025.
//

import Foundation

struct DiscountCode: Codable, Identifiable {
    let id: Int
    let code: String
}

struct Response: Codable {
    let discount_codes: [DiscountCode]
}

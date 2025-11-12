//
//  OrderStatus.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 09/11/2025.
//

import Foundation
import SwiftUI


import Foundation

struct ShopifyOrdersResponse: Codable {
    let orders: [ShopifyOrder]
}

struct ShopifyOrder: Codable, Identifiable {
    let id: Int
    let name: String?
    let total_price: String?
    let financial_status: String?
    let created_at: String?
    let line_items: [ShopifyLineItem]?
    let order_status_url: String?
}

struct ShopifyLineItem: Codable, Identifiable {
    let id: Int
    let title: String
    let quantity: Int
    let price: String
}

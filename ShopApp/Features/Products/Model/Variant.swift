//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 24/10/2025.
//

import Foundation
struct Variant: Decodable, Identifiable {
    let id, productID: Int
    let title, price: String
    let position: Int
    let inventoryPolicy: String
    let compareAtPrice: String
    let option1, option2, option3: String
    let createdAt, updatedAt: String
    let taxable: Bool
    let barcode: String
    let fulfillmentService: String
    let grams: Int
    let inventoryManagement: String
    let requiresShipping: Bool
    let sku: String
    let weight: Double
    let weightUnit: String
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
    let adminGraphqlAPIID: String
    let imageID: Int

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, position
        case inventoryPolicy = "inventory_policy"
        case compareAtPrice = "compare_at_price"
        case option1, option2, option3
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable, barcode
        case fulfillmentService = "fulfillment_service"
        case grams
        case inventoryManagement = "inventory_management"
        case requiresShipping = "requires_shipping"
        case sku, weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case imageID = "image_id"
    }

    init(from c: Decoder) throws {
        let container = try c.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        productID = try container.decodeIfPresent(Int.self, forKey: .productID) ?? 0
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        price = try container.decodeIfPresent(String.self, forKey: .price) ?? ""
        position = try container.decodeIfPresent(Int.self, forKey: .position) ?? 0
        inventoryPolicy = try container.decodeIfPresent(String.self, forKey: .inventoryPolicy) ?? ""
        compareAtPrice = try container.decodeIfPresent(String.self, forKey: .compareAtPrice) ?? ""
        option1 = try container.decodeIfPresent(String.self, forKey: .option1) ?? ""
        option2 = try container.decodeIfPresent(String.self, forKey: .option2) ?? ""
        option3 = try container.decodeIfPresent(String.self, forKey: .option3) ?? ""
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        taxable = try container.decodeIfPresent(Bool.self, forKey: .taxable) ?? false
        barcode = try container.decodeIfPresent(String.self, forKey: .barcode) ?? ""
        fulfillmentService = try container.decodeIfPresent(String.self, forKey: .fulfillmentService) ?? ""
        grams = try container.decodeIfPresent(Int.self, forKey: .grams) ?? 0
        inventoryManagement = try container.decodeIfPresent(String.self, forKey: .inventoryManagement) ?? ""
        requiresShipping = try container.decodeIfPresent(Bool.self, forKey: .requiresShipping) ?? false
        sku = try container.decodeIfPresent(String.self, forKey: .sku) ?? ""
        weight = try container.decodeIfPresent(Double.self, forKey: .weight) ?? 0.0
        weightUnit = try container.decodeIfPresent(String.self, forKey: .weightUnit) ?? ""
        inventoryItemID = try container.decodeIfPresent(Int.self, forKey: .inventoryItemID) ?? 0
        inventoryQuantity = try container.decodeIfPresent(Int.self, forKey: .inventoryQuantity) ?? 0
        oldInventoryQuantity = try container.decodeIfPresent(Int.self, forKey: .oldInventoryQuantity) ?? 0
        adminGraphqlAPIID = try container.decodeIfPresent(String.self, forKey: .adminGraphqlAPIID) ?? ""
        imageID = try container.decodeIfPresent(Int.self, forKey: .imageID) ?? 0
    }
}

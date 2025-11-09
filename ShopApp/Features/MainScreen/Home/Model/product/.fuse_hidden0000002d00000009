//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 24/10/2025.
//

import Foundation
import SwiftData

@Model
final class Variant: Identifiable, Codable {
    @Attribute(.unique) var id: Int
    var productID: Int
    var title: String
    var price: String
    var position: Int
    var inventoryPolicy: String
    var compareAtPrice: String
    var option1: String
    var option2: String
    var option3: String
    var createdAt: String
    var updatedAt: String
    var taxable: Bool
    var barcode: String
    var fulfillmentService: String
    var grams: Int
    var inventoryManagement: String
    var requiresShipping: Bool
    var sku: String
    var weight: Double
    var weightUnit: String
    var inventoryItemID: Int
    var inventoryQuantity: Int
    var oldInventoryQuantity: Int
    var adminGraphqlAPIID: String
    var imageID: Int

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

    // MARK: - Init
    init(
        id: Int = 0,
        productID: Int = 0,
        title: String = "",
        price: String = "",
        position: Int = 0,
        inventoryPolicy: String = "",
        compareAtPrice: String = "",
        option1: String = "",
        option2: String = "",
        option3: String = "",
        createdAt: String = "",
        updatedAt: String = "",
        taxable: Bool = false,
        barcode: String = "",
        fulfillmentService: String = "",
        grams: Int = 0,
        inventoryManagement: String = "",
        requiresShipping: Bool = false,
        sku: String = "",
        weight: Double = 0,
        weightUnit: String = "",
        inventoryItemID: Int = 0,
        inventoryQuantity: Int = 0,
        oldInventoryQuantity: Int = 0,
        adminGraphqlAPIID: String = "",
        imageID: Int = 0
    ) {
        self.id = id
        self.productID = productID
        self.title = title
        self.price = price
        self.position = position
        self.inventoryPolicy = inventoryPolicy
        self.compareAtPrice = compareAtPrice
        self.option1 = option1
        self.option2 = option2
        self.option3 = option3
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.taxable = taxable
        self.barcode = barcode
        self.fulfillmentService = fulfillmentService
        self.grams = grams
        self.inventoryManagement = inventoryManagement
        self.requiresShipping = requiresShipping
        self.sku = sku
        self.weight = weight
        self.weightUnit = weightUnit
        self.inventoryItemID = inventoryItemID
        self.inventoryQuantity = inventoryQuantity
        self.oldInventoryQuantity = oldInventoryQuantity
        self.adminGraphqlAPIID = adminGraphqlAPIID
        self.imageID = imageID
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(Int.self, forKey: .id) ?? 0
        productID = try c.decodeIfPresent(Int.self, forKey: .productID) ?? 0
        title = try c.decodeIfPresent(String.self, forKey: .title) ?? ""
        price = try c.decodeIfPresent(String.self, forKey: .price) ?? ""
        position = try c.decodeIfPresent(Int.self, forKey: .position) ?? 0
        inventoryPolicy = try c.decodeIfPresent(String.self, forKey: .inventoryPolicy) ?? ""
        compareAtPrice = try c.decodeIfPresent(String.self, forKey: .compareAtPrice) ?? ""
        option1 = try c.decodeIfPresent(String.self, forKey: .option1) ?? ""
        option2 = try c.decodeIfPresent(String.self, forKey: .option2) ?? ""
        option3 = try c.decodeIfPresent(String.self, forKey: .option3) ?? ""
        createdAt = try c.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try c.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        taxable = try c.decodeIfPresent(Bool.self, forKey: .taxable) ?? false
        barcode = try c.decodeIfPresent(String.self, forKey: .barcode) ?? ""
        fulfillmentService = try c.decodeIfPresent(String.self, forKey: .fulfillmentService) ?? ""
        grams = try c.decodeIfPresent(Int.self, forKey: .grams) ?? 0
        inventoryManagement = try c.decodeIfPresent(String.self, forKey: .inventoryManagement) ?? ""
        requiresShipping = try c.decodeIfPresent(Bool.self, forKey: .requiresShipping) ?? false
        sku = try c.decodeIfPresent(String.self, forKey: .sku) ?? ""
        weight = try c.decodeIfPresent(Double.self, forKey: .weight) ?? 0
        weightUnit = try c.decodeIfPresent(String.self, forKey: .weightUnit) ?? ""
        inventoryItemID = try c.decodeIfPresent(Int.self, forKey: .inventoryItemID) ?? 0
        inventoryQuantity = try c.decodeIfPresent(Int.self, forKey: .inventoryQuantity) ?? 0
        oldInventoryQuantity = try c.decodeIfPresent(Int.self, forKey: .oldInventoryQuantity) ?? 0
        adminGraphqlAPIID = try c.decodeIfPresent(String.self, forKey: .adminGraphqlAPIID) ?? ""
        imageID = try c.decodeIfPresent(Int.self, forKey: .imageID) ?? 0
    }

    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(productID, forKey: .productID)
        try c.encode(title, forKey: .title)
        try c.encode(price, forKey: .price)
        try c.encode(position, forKey: .position)
        try c.encode(inventoryPolicy, forKey: .inventoryPolicy)
        try c.encode(compareAtPrice, forKey: .compareAtPrice)
        try c.encode(option1, forKey: .option1)
        try c.encode(option2, forKey: .option2)
        try c.encode(option3, forKey: .option3)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(updatedAt, forKey: .updatedAt)
        try c.encode(taxable, forKey: .taxable)
        try c.encode(barcode, forKey: .barcode)
        try c.encode(fulfillmentService, forKey: .fulfillmentService)
        try c.encode(grams, forKey: .grams)
        try c.encode(inventoryManagement, forKey: .inventoryManagement)
        try c.encode(requiresShipping, forKey: .requiresShipping)
        try c.encode(sku, forKey: .sku)
        try c.encode(weight, forKey: .weight)
        try c.encode(weightUnit, forKey: .weightUnit)
        try c.encode(inventoryItemID, forKey: .inventoryItemID)
        try c.encode(inventoryQuantity, forKey: .inventoryQuantity)
        try c.encode(oldInventoryQuantity, forKey: .oldInventoryQuantity)
        try c.encode(adminGraphqlAPIID, forKey: .adminGraphqlAPIID)
        try c.encode(imageID, forKey: .imageID)
    }
}

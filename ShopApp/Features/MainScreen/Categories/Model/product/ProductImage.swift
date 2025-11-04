//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 24/10/2025.
//
//FIRST

import Foundation
import SwiftData

@Model
final class ProductImage: Identifiable, Codable {
    @Attribute(.unique) var id: Int
    var position: Int
    var productID: Int
    var alt: String
    var createdAt: String
    var updatedAt: String
    var adminGraphqlAPIID: String
    var width: Int
    var height: Int
    var src: String
    var variantIDs: [Int]

    enum CodingKeys: String, CodingKey {
        case id, position
        case productID = "product_id"
        case alt
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case width, height, src
        case variantIDs = "variant_ids"
    }

    // MARK: - Init
    init(
        id: Int = 0,
        position: Int = 0,
        productID: Int = 0,
        alt: String = "",
        createdAt: String = "",
        updatedAt: String = "",
        adminGraphqlAPIID: String = "",
        width: Int = 0,
        height: Int = 0,
        src: String = "",
        variantIDs: [Int] = []
    ) {
        self.id = id
        self.position = position
        self.productID = productID
        self.alt = alt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.adminGraphqlAPIID = adminGraphqlAPIID
        self.width = width
        self.height = height
        self.src = src
        self.variantIDs = variantIDs
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(Int.self, forKey: .id) ?? 0
        position = try c.decodeIfPresent(Int.self, forKey: .position) ?? 0
        productID = try c.decodeIfPresent(Int.self, forKey: .productID) ?? 0
        alt = try c.decodeIfPresent(String.self, forKey: .alt) ?? ""
        createdAt = try c.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try c.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        adminGraphqlAPIID = try c.decodeIfPresent(String.self, forKey: .adminGraphqlAPIID) ?? ""
        width = try c.decodeIfPresent(Int.self, forKey: .width) ?? 0
        height = try c.decodeIfPresent(Int.self, forKey: .height) ?? 0
        src = try c.decodeIfPresent(String.self, forKey: .src) ?? ""
        variantIDs = try c.decodeIfPresent([Int].self, forKey: .variantIDs) ?? []
    }

    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(position, forKey: .position)
        try c.encode(productID, forKey: .productID)
        try c.encode(alt, forKey: .alt)
        try c.encode(createdAt, forKey: .createdAt)
        try c.encode(updatedAt, forKey: .updatedAt)
        try c.encode(adminGraphqlAPIID, forKey: .adminGraphqlAPIID)
        try c.encode(width, forKey: .width)
        try c.encode(height, forKey: .height)
        try c.encode(src, forKey: .src)
        try c.encode(variantIDs, forKey: .variantIDs)
    }
}

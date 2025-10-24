//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 24/10/2025.
//

import Foundation

struct ProductImage: Decodable, Identifiable {
    let id, position, productID: Int
    let alt: String
    let createdAt, updatedAt: String
    let adminGraphqlAPIID: String
    let width, height: Int
    let src: String
    let variantIDs: [Int]

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

    init(from c: Decoder) throws {
        let container = try c.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        position = try container.decodeIfPresent(Int.self, forKey: .position) ?? 0
        productID = try container.decodeIfPresent(Int.self, forKey: .productID) ?? 0
        alt = try container.decodeIfPresent(String.self, forKey: .alt) ?? ""
        createdAt = try container.decodeIfPresent(String.self, forKey: .createdAt) ?? ""
        updatedAt = try container.decodeIfPresent(String.self, forKey: .updatedAt) ?? ""
        adminGraphqlAPIID = try container.decodeIfPresent(String.self, forKey: .adminGraphqlAPIID) ?? ""
        width = try container.decodeIfPresent(Int.self, forKey: .width) ?? 0
        height = try container.decodeIfPresent(Int.self, forKey: .height) ?? 0
        src = try container.decodeIfPresent(String.self, forKey: .src) ?? ""
        variantIDs = try container.decodeIfPresent([Int].self, forKey: .variantIDs) ?? []
    }
}

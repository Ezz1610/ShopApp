//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 24/10/2025.
//

import Foundation
struct ProductOption: Decodable, Identifiable {
    let id, productID, position: Int
    let name: String
    let values: [String]

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position, name, values
    }

    init(from c: Decoder) throws {
        let container = try c.container(keyedBy: CodingKeys.self)

        id = try container.decodeIfPresent(Int.self, forKey: .id) ?? 0
        productID = try container.decodeIfPresent(Int.self, forKey: .productID) ?? 0
        position = try container.decodeIfPresent(Int.self, forKey: .position) ?? 0
        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
        values = try container.decodeIfPresent([String].self, forKey: .values) ?? []
    }
}

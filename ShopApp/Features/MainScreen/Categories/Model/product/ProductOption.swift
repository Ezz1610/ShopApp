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
final class ProductOption: Identifiable, Codable {
    // MARK: - Properties
    @Attribute(.unique) var id: Int
    var name: String
    var position: Int
    var values: [String]

    // MARK: - Relationships
    var productID: Int

    // MARK: - Coding Keys
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case position
        case values
        case productID = "product_id"
    }

    // MARK: - Init
    init(
        id: Int = 0,
        name: String = "",
        position: Int = 0,
        values: [String] = [],
        productID: Int = 0
    ) {
        self.id = id
        self.name = name
        self.position = position
        self.values = values
        self.productID = productID
    }

    // MARK: - Decodable
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(Int.self, forKey: .id) ?? 0
        name = try c.decodeIfPresent(String.self, forKey: .name) ?? ""
        position = try c.decodeIfPresent(Int.self, forKey: .position) ?? 0
        values = try c.decodeIfPresent([String].self, forKey: .values) ?? []
        productID = try c.decodeIfPresent(Int.self, forKey: .productID) ?? 0
    }

    // MARK: - Encodable
    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(position, forKey: .position)
        try c.encode(values, forKey: .values)
        try c.encode(productID, forKey: .productID)
    }
}

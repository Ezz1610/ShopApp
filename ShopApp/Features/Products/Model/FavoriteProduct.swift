//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 25/10/2025.
//

import Foundation
import SwiftData

// MARK: - Favorite Product Model
@Model
final class FavoriteProduct: Identifiable {
    @Attribute(.unique) var id: Int
    var title: String
    var imageSrc: String
    var price: Double
    
    init(id: Int, title: String, imageSrc: String, price: Double) {
        self.id = id
        self.title = title
        self.imageSrc = imageSrc
        self.price = price
    }
}


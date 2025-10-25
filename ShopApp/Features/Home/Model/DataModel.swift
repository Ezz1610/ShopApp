//
//  DataModel.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//

import Foundation

struct Product: Identifiable, Decodable {
    let id: Int
    let title: String
    let vendor: String?
    let image: ProductImage?
    let variants: [Variant]?

    struct ProductImage: Decodable {
        let src: String?
    }

    struct Variant: Decodable {
        let price: String?
    }
}

struct ProductsResponse: Decodable {
    let products: [Product]
}


struct Brand: Identifiable, Decodable {
    let id: Int
    let title: String
    let image: BrandImage?

    struct BrandImage: Decodable {
        let src: String?
    }
}

struct BrandsResponse: Decodable {
    let custom_collections: [Brand]
}

struct SmartCollectionResponse: Decodable {
    let smart_collections: [SmartCollection]
}

struct SmartCollection: Identifiable, Decodable {
    let id: Int
    let title: String          
    let image: SmartImage?
}

struct SmartImage: Decodable {
    let src: String?
}

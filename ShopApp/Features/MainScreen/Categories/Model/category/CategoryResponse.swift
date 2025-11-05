//
//  DataModel.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//

import Foundation



struct CategoryResponse: Codable{
    let custom_collections : [Category]
}
struct Category: Codable, Identifiable,Hashable {
    let id: Int
    let title: String
    let image: CategoryImage?
}
struct CategoryImage: Codable, Hashable{
    let src: String?
}

struct CategoriesResponse: Decodable {
    let custom_collections: [Category]
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


//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 25/10/2025.
//
//FIRST


import SwiftData
import Foundation

@MainActor
final class SwiftDataHelper {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    // MARK: - Toggle Favorite
    func toggleFavorite(product: ProductModel) {
        if let existing = fetchFavorite(by: product.id) {
            // ✅ Already in favorites → remove it
            context.delete(existing)
        } else {
            let productPrice = product.variants.first?.price ?? ""
            print("wwwwwwwwwwww\(productPrice)")

            let safeProduct = ProductModel(
                id: product.id,
                title: product.title,
                bodyHTML: product.bodyHTML,
                vendor: product.vendor,
                productType: product.productType,
                createdAt: product.createdAt,
                updatedAt: product.updatedAt,
                publishedAt: product.publishedAt,
                handle: product.handle,
                templateSuffix: product.templateSuffix,
                publishedScope: product.publishedScope,
                tags: product.tags,
                status: product.status,
                adminGraphqlAPIID: product.adminGraphqlAPIID,
                price: productPrice, // ✅ السعر من الـ variant
                variants: product.variants,
                options: product.options,
                images: product.images,
                image: product.image
            )
            context.insert(safeProduct)
        }

        do {
            try context.save()
        } catch {
            print("❌ Error saving favorite: \(error.localizedDescription)")
        }
    }

    // MARK: - Fetch Single Favorite
    func fetchFavorite(by id: Int) -> ProductModel? {
        let descriptor = FetchDescriptor<ProductModel>(
            predicate: #Predicate { $0.id == id }
        )
        return try? context.fetch(descriptor).first
    }

    // MARK: - Fetch All Favorites
    func fetchAllFavorites() -> [ProductModel] {
        (try? context.fetch(FetchDescriptor<ProductModel>())) ?? []
    }

    // MARK: - Check if Favorite
    func isFavorite(_ id: Int) -> Bool {
        fetchFavorite(by: id) != nil
    }

    // MARK: - Remove Favorite
    func removeFavorite(id: Int) {
        if let favorite = fetchFavorite(by: id) {
            context.delete(favorite)
            do {
                try context.save()
            } catch {
                print("❌ Error removing favorite: \(error.localizedDescription)")
            }
        }
    }
}

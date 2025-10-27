//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 25/10/2025.
//
import SwiftData
import Foundation


@MainActor
final class SwiftDataHelper {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func toggleFavorite(product: ProductModel) {
        if let existing = fetchFavorite(by: product.id) {
            context.delete(existing)
        } else {
            let price = Double(product.variants.first?.price ?? "0") ?? 0
            let fav = FavoriteProduct(
                id: product.id,
                title: product.title,
                imageSrc: product.image?.src ?? "",
                price: price
            )
            context.insert(fav)
        }

        do {
            try context.save()
        } catch {
            print("Error saving favorite: \(error)")
        }
    }

    func fetchFavorite(by id: Int) -> FavoriteProduct? {
        let descriptor = FetchDescriptor<FavoriteProduct>(
            predicate: #Predicate { $0.id == id }
        )
        return try? context.fetch(descriptor).first
    }

    func fetchAllFavorites() -> [FavoriteProduct] {
        (try? context.fetch(FetchDescriptor<FavoriteProduct>())) ?? []
    }

    func isFavorite(_ id: Int) -> Bool {
        fetchFavorite(by: id) != nil
    }

    func removeFavorite(id: Int) {
        if let favorite = fetchFavorite(by: id) {
            context.delete(favorite)
            try? context.save()
        }
    }
}

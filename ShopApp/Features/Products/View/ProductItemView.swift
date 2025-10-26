//
//  pp.swift
//  ShopApp
//
//  Created by mohamed ezz on 25/10/2025.
//
import Foundation
import SwiftUI
import SwiftData

struct ProductItemView: View {
    var product: ProductModel?
    var favorite: FavoriteProduct?
    var isFavorite: Bool
    var onToggleFavorite: () -> Void
    var onTap: (() -> Void)? = nil

    private var imageURL: URL? {
        if let product = product {
            return URL(string: product.image?.src ?? "")
        } else if let favorite = favorite {
            return URL(string: favorite.imageSrc)
        }
        return nil
    }

    private var title: String {
        product?.title ?? favorite?.title ?? "Unknown"
    }

    private var priceText: String {
        if let product = product {
            return "$\(product.variants.first?.price ?? "-")"
        } else if let favorite = favorite {
            return String(format: "$%.2f", favorite.price)
        }
        return "$0.00"
    }

    var body: some View {
        VStack(spacing: 10) {
            AsyncImage(url: imageURL) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(height: 150)
                    .cornerRadius(12)
                    .clipped()
            } placeholder: {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 150)
                    ProgressView()
                }
            }
            .onTapGesture { onTap?() }

            VStack(alignment: .center, spacing: 6) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)

                Text(priceText)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.accentColor)
            }

            HStack {
                Spacer()
                Button(action: onToggleFavorite) {
                    Image(systemName: isFavorite ? "heart.fill" : "heart")
                        .foregroundColor(isFavorite ? .red : .gray)
                        .font(.title3)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(10)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.06), radius: 6, x: 0, y: 4)
    }
}

//
//  CategoryTile.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 26/10/2025.
//

import SwiftUI

struct CategoryTile: View {
    let category: Category
    var body: some View {
        NavigationLink {
            CategoryProductsPage(category: category)
        } label: {
            VStack(spacing: 8) {
                AsyncImage(url: URL(string: category.image?.src ?? "")) { phase in
                    switch phase {
                    case .empty:
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.15))
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.15))
                            .overlay(
                                Image(systemName: "photo")
                                    .font(.title3)
                                    .foregroundColor(.gray)
                            )
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                Text(category.title)
                    .font(.caption)
                    .foregroundColor(.primary)
                    .lineLimit(1)
            }
            .frame(width: 80)
        }
        .buttonStyle(.plain)

    }
}

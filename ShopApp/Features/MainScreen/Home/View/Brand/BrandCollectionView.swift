//
//  BrandCollectionView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 25/10/2025.
//
import SwiftUI

struct BrandCollectionView: View {
    let brands: [SmartCollection]
    @ObservedObject var homeVM: HomeViewModel

    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Brands")
                .font(.system(size: 18, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)

            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(brands, id: \.id) { brand in
                    NavigationLink(
                        destination: BrandProductsView(
                            brand: brand,
                            homeVM: homeVM
                        )
                    ) {
                        BrandCardLuxury(brand: brand)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 32)
        }
        .background(Color(.systemGray6))
    }
}

// MARK: - Brand Card
private struct BrandCardLuxury: View {
    let brand: SmartCollection

    var body: some View {
        VStack(spacing: 10) {
            AsyncImage(url: URL(string: brand.image?.src ?? "")) { phase in
                switch phase {
                case .empty:
                    Rectangle()
                        .fill(Color.gray.opacity(0.05))
                        .overlay(ProgressView().scaleEffect(0.7))
                case .success(let img):
                    img
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 50)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 8)
                case .failure:
                    Rectangle()
                        .fill(Color.gray.opacity(0.05))
                        .overlay(
                            Image(systemName: "photo")
                                .font(.title3)
                                .foregroundColor(.gray)
                        )
                @unknown default: EmptyView()
                }
            }
            .frame(height: 60)

            Text(brand.title.uppercased())
                .font(.system(size: 11, weight: .medium, design: .rounded))
                .foregroundColor(.primary)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity, minHeight: 28, alignment: .top)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.04), radius: 4, x: 0, y: 2)
        )
    }
}

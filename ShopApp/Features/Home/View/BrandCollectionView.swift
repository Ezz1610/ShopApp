//
//  BrandCollectionView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 25/10/2025.
//

import SwiftUI

struct BrandCollectionView: View {
    let brands: [SmartCollection]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            Text("Brands")
                .font(.headline)
                .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {

                LazyHGrid(
                    rows: [
                        GridItem(.fixed(110)),
                        GridItem(.fixed(110))
                    ],
                    spacing: 12
                ) {

                    ForEach(brands) { brand in
                        NavigationLink(
                            destination: BrandProductsView(vendor: brand.title)
                        ) {
                            VStack(spacing: 8) {

                                AsyncImage(url: URL(string: brand.image?.src ?? "")) { img in
                                    img
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color(.systemGray5)
                                }
                                .frame(width: 110, height: 80)
                                .cornerRadius(10)

                                Text(brand.title)
                                    .font(.caption)
                                    .lineLimit(1)
                            }
                            .frame(width: 110)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 2)
                        }
                    }

                }
                .padding(.horizontal)
            }
        }
    }
}

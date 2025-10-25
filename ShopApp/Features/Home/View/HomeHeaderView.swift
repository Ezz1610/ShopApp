//
//  point.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//

import SwiftUI

struct HomeHeaderView: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {

            HStack(spacing: 10) {

                Image("appicon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 34, height: 34)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(color: .black.opacity(0.08), radius: 3, x: 0, y: 1)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Shopyfiy")
                        .font(.system(size: 18, weight: .semibold, design: .rounded))
                        .foregroundColor(.primary)

                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.yellow)

                        Text("Shop smart")
                            .font(.system(size: 11, weight: .medium, design: .rounded))
                            .foregroundColor(.secondary)
                    }
                }
            }

            Spacer()

            HStack(spacing: 12) {

                // Favorites
                Button {
                    // favorites action
                } label: {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.black.opacity(0.05))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "heart.fill")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)
                        )
                }

                // Cart
                Button {
                    // cart action
                } label: {
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(Color.black.opacity(0.05))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "cart.fill")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.primary)
                        )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 4)
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeHeaderView()
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color(.systemGray6))
}

//
//  CategoryChip.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 26/10/2025.
//

import SwiftUI


struct CategoryChip: View {
    let category: Category
    let isSelected: Bool
    let onTap: () async -> Void   // ✅ async closure

    var body: some View {
        Button {
            Task {
                await onTap()
            }
        } label: {
            Text(category.title.capitalized)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular, design: .rounded))
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(isSelected ? Color.black : Color.white)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .stroke(isSelected ? Color.black : Color.gray.opacity(0.4), lineWidth: 1)
                        )
                )
                .shadow(color: isSelected ? .black.opacity(0.08) : .clear, radius: 4, x: 0, y: 2)
        }
        .buttonStyle(.plain)
    }
}

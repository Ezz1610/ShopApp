//
//  ProductsView.swift
//  ShopApp
//
//  Created by Mohammed Hassanien on 23/10/2025.
//
import SwiftUI

struct HomeSearchBar: View {
    @Binding var searchText: String
    @FocusState private var isFocused: Bool

    var body: some View {
        HStack(spacing: 8) {

            Image(systemName: "magnifyingglass")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black.opacity(0.6))

            TextField("Search products or brands", text: $searchText)
                .font(.system(size: 15, weight: .regular, design: .rounded))
                .foregroundColor(.black)
                .disableAutocorrection(true)
                .focused($isFocused)
                .onSubmit { isFocused = false }

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray.opacity(0.6))
                        .font(.system(size: 16))
                }
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 44)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color.black.opacity(0.05))
        )
        .padding(.horizontal, 16)
        .padding(.top, 8)
    }
}

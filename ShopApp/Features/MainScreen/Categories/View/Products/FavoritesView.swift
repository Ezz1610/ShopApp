//
//  FavoritesView.swift
//  ShopApp
//
//  Created by mohamed ezz on 02/11/2025.
//

import Foundation
import SwiftUI
import SwiftData

struct FavoritesView: View {
@EnvironmentObject private var navigator: AppNavigator
@StateObject private var viewModel: CategoriesProductsViewModel
@State private var localFavorites: [ProductModel] = []


init(context: ModelContext) {
    _viewModel = StateObject(wrappedValue: CategoriesProductsViewModel(context: context))
}

var body: some View {
    VStack(spacing: 0) {
        header

        if localFavorites.isEmpty {
            emptyState
        } else {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(localFavorites, id: \.id) { product in
                        ProductCardView(product: product, viewModel: viewModel)
                            .frame(maxWidth: .infinity)
                            .onTapGesture { navigator.goTo(.productDetails(product)) }
                    }
                }
                .padding()
            }
        }
    }
    .task { refreshLocalFavorites() }
    // ✅ استخدم onReceive لمتابعة التغيرات بدلاً من onChange
    .onReceive(viewModel.$favorites) { _ in
        refreshLocalFavorites()
    }
    .navigationBarBackButtonHidden(true)
    .background(Color(.systemGroupedBackground))
}

private func refreshLocalFavorites() {
    Task { @MainActor in
        localFavorites = viewModel.favorites
    }
}

private var header: some View {
    HStack {
        Button(action: { navigator.goBack() }) {
            HStack(spacing: 6) { Image(systemName: "chevron.left"); Text("Back") }
                .foregroundColor(.blue)
        }
        Spacer()
        Text("Favorites").font(.title2.bold())
        Spacer()
        Spacer().frame(width: 60)
    }
    .padding()
    .background(Color(.systemGray6))
}

private var emptyState: some View {
    VStack(spacing: 12) {
        Image(systemName: "heart.slash").resizable().scaledToFit().frame(width: 80, height: 80).foregroundColor(.gray)
        Text("No favorites yet").font(.headline).foregroundColor(.secondary)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}


}

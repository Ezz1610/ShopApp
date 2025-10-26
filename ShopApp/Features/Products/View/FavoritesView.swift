//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 25/10/2025.
//

import SwiftUI
import SwiftData



struct FavoritesView: View {
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var navigator: AppNavigator
    @StateObject private var viewModel: ProductsViewModel

    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: ProductsViewModel(context: context))
    }

    var body: some View {
        VStack {
            header

            if viewModel.favorites.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                        ForEach(viewModel.favorites, id: \.id) { favorite in
                            ProductItemView(
                                favorite: favorite,
                                isFavorite: true,
                                onToggleFavorite: { viewModel.removeFavorite(favorite) }
                            )
                        }
                    }
                    .padding()
                }
            }
        }
        .onAppear { viewModel.loadFavorites() }
        .navigationBarBackButtonHidden(true)
    }

    private var header: some View {
        HStack {
            Button(action: { navigator.goBack() }) {
                HStack(spacing: 6) {
                    Image(systemName: "chevron.left")
                    Text("Back")
                }
                .foregroundColor(.blue)
            }

            Spacer()
            Text("Favorites")
                .font(.title2.bold())
            Spacer()
            Spacer().frame(width: 60)
        }
        .padding()
        .background(Color(.systemGray6))
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.slash")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            Text("No favorites yet")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

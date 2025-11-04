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
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var navigator: AppNavigator
    @StateObject private var viewModel: CategoriesProductsViewModel

    // MARK: - Init
    init(context: ModelContext) {
        _viewModel = StateObject(wrappedValue: CategoriesProductsViewModel(context: context))
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            header

            if viewModel.favorites.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(viewModel.favorites, id: \.id) { product in
                            ProductCardView(product: product, viewModel: viewModel)
                                .frame(maxWidth: .infinity)
                                .onTapGesture {
                                    navigator.goTo(.productDetails(product))
                                }
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.refreshFavorites()
        }
        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGroupedBackground))
    }

    // MARK: - Header
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

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "heart.slash")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(.gray)
            Text("No favorites yet")
                .font(.headline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


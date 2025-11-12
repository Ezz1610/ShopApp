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
    @StateObject private var viewModel: HomeViewModel
    @State private var localFavorites: [ProductModel] = []

    init(context: ModelContext) {
        HomeViewModel.initializeSingleton(context: context)
        _viewModel = StateObject(wrappedValue: HomeViewModel.shared!)
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
                                .onTapGesture { navigator.goTo(.productDetails(product , NavigateFrom.fromFavorites), replaceLast: true) }
                        }
                    }
                    .padding()
                }
            }
        }
        .task {
            await viewModel.refreshFavorites()

            refreshLocalFavorites()
        }
        .onReceive(viewModel.$favorites) { _ in
            refreshLocalFavorites()
        }

        .navigationBarBackButtonHidden(true)
        .background(Color(.systemGroupedBackground))
    }

    private func refreshLocalFavorites() {
        Task { @MainActor in
            localFavorites = viewModel.favorites
            print("fffffffff\(viewModel.favorites.count)")

        }
        print("fffffffff")
    }

    private var header: some View {
        HStack {
            Button(action: { navigator.goBack() }) {
                HStack(spacing: 6) { Image(systemName: "chevron.left"); Text("Home") }
                    .foregroundColor(.black)
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

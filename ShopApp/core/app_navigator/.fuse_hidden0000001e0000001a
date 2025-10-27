//
//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import Foundation

import SwiftUI



struct RootView: View {
    @EnvironmentObject var navigator: AppNavigator
    @Environment(\.modelContext) private var context   // ✅ Needed for SwiftData Views

    var body: some View {
        NavigationStack {
            switch navigator.currentScreen {
            case .login:
                LoginScreen()

            case .register:
                RegisterScreen()

            case .testHome:
                TestHomeScreen(context: context)   // ✅ Pass the model context

            case .productsView:
                ProductsView(context: context)

            case .favoritesView:
                FavoritesView(context: context)   // ✅ Also uses context

            case .productDetails(let product):
                ProductDetailsView(product: product)
            }
        }
        .animation(.easeInOut, value: navigator.currentScreen)
    }
}

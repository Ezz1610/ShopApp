////FIRST

//  File.swift
//  ShopApp
//
//  Created by mohamed ezz on 21/10/2025.
//

import Foundation

import SwiftUI


struct RootView: View {
    @EnvironmentObject var navigator: AppNavigator
    @Environment(\.modelContext) private var context
    @State private var cartManager = CartManager() // ✅ خليه State

    var body: some View {
        NavigationStack {
            switch navigator.currentScreen {
            case .login:
                LoginScreen()

            case .register:
                RegisterScreen()
            case .cartView:
                CartView()

            case .mainTabView:
                MainTabView()
                    .environment(cartManager) // ✅ مرره هنا

            case .favoritesView:
                FavoritesView(context: context)
                    .environment(cartManager) // ✅ كده يوصل لكل الشاشات

            case .productDetails(let product):
                ProductDetailsView(product: product)
                    .environment(cartManager)

            case .homeView:
                HomeView(context: context)
                    .environment(cartManager)
            }
        }
        .animation(.easeInOut, value: navigator.currentScreen)
    }
}

